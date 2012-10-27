namespace Tryangle {

	abstract class TryangleBase : GLib.Object {

		private int intPools;
		public Gee.HashMap<string, string> mapConfig;
		public Gee.ArrayList<ClientPool> lstPools;
		public GLib.SocketService objServer;
		
		construct {
			this.mapConfig = new Gee.HashMap<string, string>();
			this.lstPools = new Gee.ArrayList<ClientPool>();
			Posix.signal(Posix.SIGINT, handleSignal);
			Posix.signal(Posix.SIGTERM, handleSignal);
		}
		
		private static void handleSignal(int intSignal){
			Logger.Log("Shutting down..", Logger.Level.Info);
			Posix.exit(0);
		}
		
		public virtual void addPoolClient(Client objClient){
			if(this.lstPools != null){
				foreach(ClientPool objPool in this.lstPools){
					if(objPool.intClients >= int.parse(this.mapConfig["maxPoolClients"])) continue;
					objPool.addClient(objClient);
				}
			}
		}
		
		public virtual void initializeClientPool(){
			ClientPool objPool = new ClientPool(this as Tryangle);
			this.lstPools.add(objPool);
			this.intPools++;
			GLib.Thread objThread = new GLib.Thread<void*>("ClientPool", objPool.run);
		}
		
		public virtual void removePool(ClientPool objPool){
			this.lstPools.remove(objPool);
			this.intPools--;
			Logger.Log("Client pool closed", Logger.Level.Info);
		}

		public virtual void run(){
			GLib.Socket objSocket;
			while(true){
				try {
					objSocket = this.objServer.accept_socket();
				} catch(GLib.Error objError){
					Logger.Log(objError.message, Logger.Level.Error);
					continue;
				}
				if(objSocket != null){
					Logger.Log("Incoming client", Logger.Level.Info);
					if(this.intPools == 0){
						this.initializeClientPool();
					}
					if(!this.slotsAvailable() && this.intPools < int.parse(this.mapConfig["maxPools"])){
						this.initializeClientPool();
					} else if(!this.slotsAvailable() && this.intPools >= int.parse(this.mapConfig["maxPools"])){
						Logger.Log("Client limit reached!", Logger.Level.Warn);
						continue;
					}
					this.addPoolClient(new Client(objSocket));
				}
			}
		}
		
		public virtual bool slotsAvailable(){
			if(this.lstPools == null) return true;
			bool blnSlotAvailable = false;
			foreach(ClientPool objPool in this.lstPools){
				if(objPool.intClients < int.parse(this.mapConfig["maxPoolClients"])){
					blnSlotAvailable = true;
				}
			}
			return blnSlotAvailable;
		}
		
	}
	
}
