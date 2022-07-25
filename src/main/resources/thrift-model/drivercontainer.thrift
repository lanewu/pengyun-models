
include "shared.thrift"
include "icshared.thrift"

namespace java py.thrift.drivercontainer.service

exception FailedToApplyVolumeAccessRulesException_Thrift {
	1: optional string detail
}

exception FailedToCancelVolumeAccessRulesException_Thrift {
	1: optional string detail
}

exception FailedToApplyIscsiAccessRulesException_Thrift {
	1: optional string detail
}

exception FailedToCancelIscsiAccessRulesException_Thrift {
	1: optional string detail
}

service DriverContainer extends shared.DebugConfigurator {
    void ping(),
    
    //shutdown
    void shutdown(),
    
    shared.LaunchDriverResponse_Thrift launchDriver(1:shared.LaunchDriverRequest_Thrift request) throws (
    					1:shared.ExistsDriverException_Thrift ede,
                        2:shared.DriverLaunchFailedException_Thrift dlfe,
                        3:shared.ServiceHavingBeenShutdown_Thrift shbsd
                        4:shared.SystemMemoryIsNotEnough_Thrift smie,
                        5:shared.DriverIsUpgradingException_Thrift diug,
                        6:shared.DriverNameExistsException_Thrift dneet,
                        7:shared.DriverTypeIsConflictException_Thrift dcie,
                        8:shared.SystemCpuIsNotEnough_Thrift scine,
                        9:shared.UnknownIPV4HostException_Thrift ui4he,
                        10:shared.UnknownIPV6HostException_Thrift ui6he)
    
    shared.UmountDriverResponse_Thrift umountDriver(1:shared.UmountDriverRequest_Thrift request) throws (
    					1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
    					2:shared.FailedToUmountDriverException_Thrift ftde,
    					3:shared.ExistsClientException_Thrift ece,
    					4:shared.DriverIsLaunchingException_Thrift dile,
    					5:shared.DriverIsUpgradingException_Thrift diug)

    shared.ChangeDriverBoundVolumeResponse changeDriverBoundVolume(1:shared.ChangeDriverBoundVolumeRequest request) throws (
                                                                                                    1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
   																									2:shared.ServiceIsNotAvailable_Thrift sina,
   																									3:shared.ChangeDriverBoundVolumeFailed_Thrift cdbv),

    shared.GetPerformanceParameterResponse_Thrift pullPerformanceParameter(1:shared.GetPerformanceParameterRequest_Thrift request) throws (
                        1:shared.VolumeHasNotBeenLaunchedException_Thrift vhnble,
                        2:shared.ReadPerformanceParameterFromFileException_Thrift gppffe)
    
    shared.GetPerformanceFromPYMetricsResponse_Thrift pullPerformanceFromPYMetrics(1:shared.GetPerformanceParameterRequest_Thrift request) throws (
                        1:shared.VolumeHasNotBeenLaunchedException_Thrift vhnble,
                        2:shared.ReadPerformanceParameterFromFileException_Thrift gppffe)

    shared.ApplyVolumeAccessRulesResponse applyVolumeAccessRules(1:shared.ApplyVolumeAccessRulesRequest request) throws (1:FailedToApplyVolumeAccessRulesException_Thrift ftavare), 
    
    shared.CancelVolumeAccessRulesResponse cancelVolumeAccessRules(1:shared.CancelVolumeAccessRulesRequest request) throws (1:FailedToCancelVolumeAccessRulesException_Thrift ftcvare),

    shared.ListVolumeAccessRulesByVolumeIdsResponse listVolumeAccessRulesByVolumeIds(1:shared.ListVolumeAccessRulesByVolumeIdsRequest request) throws (1:shared.ServiceIsNotAvailable_Thrift sina),

    shared.ApplyIscsiAccessRulesResponse applyIscsiAccessRules(1:shared.ApplyIscsiAccessRulesRequest request) throws (1:FailedToApplyIscsiAccessRulesException_Thrift ftavare),

    shared.CancelIscsiAccessRulesResponse cancelIscsiAccessRules(1:shared.CancelIscsiAccessRulesRequest request) throws (1:FailedToCancelIscsiAccessRulesException_Thrift ftcvare),

    shared.ListIscsiAccessRulesByDriverKeysResponse listIscsiAccessRulesByDriverKeys(1:shared.ListIscsiAccessRulesByDriverKeysRequest request) throws (1:shared.ServiceIsNotAvailable_Thrift sina),

    shared.ListIscsiAppliedAccessRulesResponse_Thrift listIscsiAppliedAccessRules(1:shared.ListIscsiAppliedAccessRulesRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd),

    icshared.ReportDriverMetadataResponse reportDriverMetadata(1:icshared.ReportDriverMetadataRequest request) throws (1:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                       2:shared.DriverFromRequestNotFoundException_Thrift drnf),
    shared.GetDriverConnectPermissionResponse_Thrift  getDriverConnectPermission(1:shared.GetDriverConnectPermissionRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd),
    
    shared.GetIOLimitationByDriverResponse_Thrift getIOLimitationsByDriver(1:shared.GetIOLimitationByDriverRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                            2:shared.ServiceIsNotAvailable_Thrift sina),

    //********** iscsi chap control begin **********/
    shared.SetIscsiChapControlResponse_Thrift  setIscsiChapControl(1:shared.SetIscsiChapControlRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd),
    //********** iscsi chap control end   **********/

    shared.MountScsiDeviceResponse mountScsiDevice(1:shared.MountScsiDeviceRequest request) throws (
                        1:shared.NoEnoughPydDeviceException_Thrift nepde,
                        2:shared.ConnectPydDeviceOperationException_Thrift cpdoe,
                        3:shared.CreateBackstoresOperationException_Thrift cboe,
                        4:shared.CreateLoopbackOperationException_Thrift cloe,
                        5:shared.CreateLoopbackLunsOperationException_Thrift clloe,
                        6:shared.GetScsiDeviceOperationException_Thrift gsdoe),

    shared.UmountScsiDeviceResponse umountScsiDevice(1:shared.UmountScsiDeviceRequest request) throws (),

}


