/**
 * This thrift defines a service interface for testing 
 */
include "infocenter.thrift"
include "shared.thrift"

namespace java py.thrift.testing.service

struct PingRequest {
    1: i64 requestId,
    2: optional binary data
}

exception TestInternalError_Thrift {
  1: optional string detail
}

service DummyTestService {
     string ping(1: PingRequest request) throws (
        1:TestInternalError_Thrift tie
        ),
        
     void pingforcoodinator(),
        
     infocenter.ReserveVolumeResponse reserveVolume(1: infocenter.ReserveVolumeRequest request) throws (
        1:TestInternalError_Thrift tie
        )

}
