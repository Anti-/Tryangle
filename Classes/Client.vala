namespace Tryangle {
	
	class Client : ClientBase {
		
		public Client(GLib.SocketConnection objConnection){
			this.objSocketConnection = objConnection;
			this.objDataInput = new GLib.DataInputStream(objConnection.input_stream);
			this.objDataOutput = new GLib.DataOutputStream(objConnection.output_stream);
		}
		
		public string recvData(){
			string? strData = null;
			try {
				strData = this.objDataInput.read_line(null);
			} catch(GLib.IOError objError){
				Logger.Log(objError.message);
			}
			return strData;
		}
		
	}
	
}
