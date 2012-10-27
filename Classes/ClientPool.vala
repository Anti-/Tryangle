namespace Tryangle {
	
	class ClientPool : GLib.Object {
		
		public int intClients;
		public Gee.HashMap<GLib.Socket, Client> mapClients;
		public Tryangle objParent;
		
		public ClientPool(Tryangle objParent){
			this.mapClients = new Gee.HashMap<GLib.Socket, Client>();
			this.objParent = objParent;
			Logger.Log("Client pool initialized", Logger.Level.Info);
		}
		
		private Gee.ArrayList<Client> getClients(){
			Gee.ArrayList<Client> arrClients = new Gee.ArrayList<Client>();
			arrClients.add_all(this.mapClients.values as Gee.Collection);
			return arrClients;
		}
		
		public void addClient(Client objClient){
			this.mapClients.set(objClient.objSocket, objClient);
			this.intClients++;
			Logger.Log("Client accepted", Logger.Level.Info);
		}
		
		public void removeClient(Client objClient){
			this.mapClients.unset(objClient.objSocket);
			this.intClients--;
			Logger.Log("Client disconnected", Logger.Level.Info);
		}
		
		public void* run(){
			Logger.Log("Client pool running", Logger.Level.Info);
			string? strData = null;
			ssize_t intRead;
			while(true){
				if(this.mapClients.size == 0){
					this.objParent.removePool(this);
					break;
				}
				Gee.ArrayList<Client> arrClients = this.getClients();
				foreach(Client objClient in arrClients){
					uint8[] bytBuffer = new uint8[1024];
					try {
						intRead = objClient.objSocket.receive(bytBuffer);
					} catch(GLib.Error objError){
						continue;
					}
					if(intRead == 0){
						this.removeClient(objClient);
						continue;
					}
					strData = (string)bytBuffer;
					/* Splitting by \0 doesn't seem to be needed; it only breaks things! */
					this.objParent.handleData(objClient, strData);
				}
			}
			return null;
		}
	}
}
