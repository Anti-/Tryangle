namespace Tryangle {

	abstract class TryangleBase : GLib.Object {
		
		private int intPools;
		public int intClients;
		public Gee.HashMap<string, string> mapConfig;
		public Gee.ArrayList<ClientPool> lstPools;
		public GLib.SocketService objServer;
		
		construct {
			this.mapConfig = new Gee.HashMap<string, string>();
			this.lstPools = new Gee.ArrayList<ClientPool>();
		}
		
		public void initializeClientPool(){
			ClientPool objPool = new ClientPool(this);
			this.lstPools.add(objPool);
			this.intPools++;
			GLib.Thread objThread = new GLib.Thread<void*>("ClientPool", objPool.run);
		}
		
		public bool slotsAvailable(){
			if(this.intClients >= int.parse(this.mapConfig["maxClients"])) return false;
			if(this.intPools >= int.parse(this.mapConfig["maxPools"])) return false;
			if(this.lstPools == null) return true;
			bool blnSlotAvailable = false;
			foreach(ClientPool objPool in this.lstPools){
				if(objPool.intClients < int.parse(this.mapConfig["maxPoolClients"])){
					blnSlotAvailable = true;
				}
			}
			return blnSlotAvailable;
		}
		
		public void addPoolClient(Client objClient){
			if(this.lstPools != null){
				foreach(ClientPool objPool in this.lstPools){
					if(objPool.intClients < int.parse(this.mapConfig["maxPoolClients"])){
						objPool.addClient(objClient);
					}
				}
				this.intClients++;
			}
		}

		public virtual void run(){
			GLib.SocketConnection? objConnection = null;
			GLib.Thread objThread;
			while(true){
				try {
					objConnection = this.objServer.accept();
				} catch(GLib.Error objError){
					Logger.Log(objError.message);
					continue;
				}
				if(objConnection != null){
					Logger.Log("Incoming client");
					if(this.intPools == 0){
						this.initializeClientPool();
					}
					if(!this.slotsAvailable()){
						Logger.Log("Client limit reached!");
					} else {
						this.addPoolClient(new Client(objConnection));
					}
				}
			}
		}
		
		public virtual void shutDown(bool blnFaithful = false){
			Posix.exit(0);
		}
		
	}
	
}
