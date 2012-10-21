namespace Tryangle {
	
	class ClientPool : GLib.Object {
		
		public void* objParent;
		public Gee.ArrayList<Client> lstClients;
		public int intClients;
		
		public ClientPool(void* objParent){
			this.lstClients = new Gee.ArrayList<Client>();
			this.objParent = objParent;
			Logger.Log("Client pool initialized");
		}
		
		public void addClient(Client objClient){
			this.lstClients.add(objClient);
			this.intClients++;
		}
		
		public void* run(){
			Logger.Log("Client pool running");
			string? strData = null;
			while(true){
				if(this.lstClients != null){
					foreach(Client objClient in this.lstClients){
						strData = objClient.recvData();
						if(strData != null){
							Logger.Log("Received data: " + strData);
						}
					}
				}
			}
			return null;
		}
		
	}
		
}
