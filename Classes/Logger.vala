namespace Tryangle {
	
	class Logger {
		
		public enum Level {
			Debug, Error, Fatal, Info, Trace, Warn
		}
		
		public static void Log(string strText, Logger.Level enuLevel){
			string strLevel;
			switch(enuLevel){
				case Logger.Level.Debug:
					strLevel = "DEBUG";
				break;
				case Logger.Level.Error:
					strLevel = "ERROR";
				break;
				case Logger.Level.Fatal:
					strLevel = "FATAL";
				break;
				case Logger.Level.Info:
					strLevel = "INFO";
				break;
				case Logger.Level.Trace:
					strLevel = "TRACE";
				break;
				case Logger.Level.Warn:
					strLevel =  "WARN";
				break;
				default:
					strLevel = "NONE";
				break;
			}
			GLib.DateTime objDateTime = new GLib.DateTime.now_local();
			string strOut = "[" + strLevel + "][" + objDateTime.get_hour().to_string() + ":" + objDateTime.get_minute().to_string() + ":" + objDateTime.get_second().to_string() + "] > " + strText;
			stdout.printf("%s%c", strOut, 10);
		}
		
	}
	
}
