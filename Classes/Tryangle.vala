namespace Tryangle {
	
	class Tryangle : TryangleBase {

		private GLib.KeyFile objParser;
		const double intVersion = 0.01;
		
		public Tryangle(string strServer){
			this.objServer = new GLib.SocketService();
			this.objParser = new GLib.KeyFile();
			uint16 intPort = 9000;
			try {
				this.objParser.load_from_file("Settings.conf", GLib.KeyFileFlags.NONE);
				intPort = (uint16)this.objParser.get_integer(strServer, "intPort");this.mapConfig["maxPoolClients"] = this.objParser.get_value(strServer, "intMaxClientPerPool");
				this.mapConfig["maxPools"] = this.objParser.get_value(strServer, "intMaxPools");
				this.objServer.add_inet_port(intPort, null);
			} catch(GLib.Error objError){
				Logger.Log(objError.message, Logger.Level.Error);
				Posix.exit(0);
			}
			this.objServer.start();
			Logger.Log("Tryangle " + intVersion.to_string() + " initialized on " + intPort.to_string(), Logger.Level.Info);
		}
		
		public void handleData(Client objClient, string strData){
			Logger.Log("Received data: " + strData, Logger.Level.Info);
		}
		
	}
	
}
