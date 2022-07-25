namespace java py.thrift.scriptcontainer.service
namespace perl scriptcontainer

struct ExecuteCommandRequest {
	1: i64 requestId,
	2: string command
}

struct ExecuteCommandResponse {
	1: i64 requestId,
}

exception FailedToExecuteCommandException_Thrift {
	1: optional string detail
}

service ScriptContainer {
	void ping(),
	
	void shutdown(),
	
	ExecuteCommandResponse executeCommand(1: ExecuteCommandRequest request) throws (1: FailedToExecuteCommandException_Thrift ftece)
}