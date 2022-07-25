/**
 * This thrift defines a service interface for testing performance 
 */

namespace java py.thrift.testing.service

struct PerformanceTestRequest_Thrift {
    1: i64 requestId,
    2: optional binary data
}

struct PerformanceTestResponse_Thrift {
    1: i64 requestId,
    2: optional binary data
}

exception PerformanceTestException_Thrift {
  1: optional string detail
}

service PerformanceTestService {
     PerformanceTestResponse_Thrift testPingPang(1: PerformanceTestRequest_Thrift request) throws (
        1: PerformanceTestException_Thrift pte
        ),
        
     PerformanceTestResponse_Thrift testRead(1: PerformanceTestRequest_Thrift request) throws (
        1: PerformanceTestException_Thrift pte
        ),
        
     PerformanceTestResponse_Thrift testWrite(1: PerformanceTestRequest_Thrift request) throws (
        1: PerformanceTestException_Thrift pte
        ),
}
