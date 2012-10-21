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
			Logger.Log("Client accepted");
		}
		
		public void* run(){
			Logger.Log("Client pool running");
			string? strData = null;
			ssize_t intRead;
			while(true){
				if(this.lstClients != null){
					foreach(Client objClient in this.lstClients){
						uint8[] bytBuffer = new uint8[1024];
						try {
							intRead = objClient.objSocket.receive(bytBuffer);
						} catch(GLib.Error objError){
							//Logger.Log(objError.message);
							continue;
						}
						if(intRead == 0){
							Logger.Log("Client disconnected");
							this.lstClients.remove(objClient);
							continue;
						}
						strData = (string)bytBuffer;
						Logger.Log("Received data: " + strData);
					}
				}
			}
			return null;
		}
		
	}
		
}
