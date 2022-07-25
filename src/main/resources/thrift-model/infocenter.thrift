include "shared.thrift"
include "icshared.thrift"
include "monitorserver.thrift"

/**
 * This thrift file define information center service and its client
 * 
 */
namespace java py.thrift.infocenter.service


/**
 * Requests and Responses
 */
// data node service sends its archive metadata to me
struct ReportArchivesRequest {
   1:i64 requestId, 
   2:shared.InstanceMetadata_Thrift instance,
   3:shared.ReportDBRequest_Thrift reportDBRequest,
   4:set<i64> volumeUpdateReportTableOk
}

struct ReportArchivesResponse {
   1:i64 requestId,
   2:shared.Group_Thrift group,
   3:shared.NextActionInfo_Thrift datanodeNextAction,
   4:map<i64, shared.NextActionInfo_Thrift> archiveIdMapNextAction,
   5:shared.ReportDBResponse_Thrift reportDBResponse,
   6:map<i64, shared.PageMigrationSpeedInfo_Thrift> archiveIdMapMigrationSpeed,
   7:map<i64, string> archiveIdMapMigrationStrategy
   8:optional map<i64,shared.CheckSecondaryInactiveThreshold_Thrift> archiveIdMapCheckSecondaryInactiveThreshold,
   9:optional shared.RebalanceTaskList_Thrift rebalanceTasks,
   //just for Equilibrium
   10:map<i64, map<i64, i64>> volumeReportToInstancesSameTime,
   11:i64 updateReportToInstancesVersion,
   12:map<i64, map<i64, i64>> updateTheDatanodeReportTable,
   13:bool equilibriumOkAndClearValue,
   14:map<i64, map<i64, shared.VolumeStatus_Thrift>> eachStoragePoolVolumesStatus
}

// data node service sends its segment units metadata to me
struct ReportSegmentUnitsMetadataRequest {
   1:i64 requestId, 
   2:i64 instanceId, 
   3:list<shared.SegmentUnitMetadata_Thrift> segUnitsMetadata
}

struct ReportSegmentUnitCloneFailRequest {
   1:i64 requestId,
   2:i64 myInstanceId,
   3:i64 volumeId,
   4:i32 segIndex
}

struct ReportSegmentUnitCloneFailResponse {
   1:i64 requestId
}

struct ReportSegmentUnitRecycleFailRequest {
   1:i64 requestId,
   2:list<shared.SegmentUnitMetadata_Thrift> segUnitsMetadata
}

struct ReportSegmentUnitRecycleFailResponse {
   1:i64 requestId
}

//this struct is used to restore the segment unit whose status is conflict to the volume status
struct SegUnitConflict_Thrift {
   1:i64 volumeId,
   2:i32 segIndex,
   3:shared.SegmentUnitStatusConflictCause_Thrift cause,
   4:optional binary mySnapshotManagerInBinary
}

// I responses with the latest segment unit metadata of all its segment units
// if the segment unit is rejected for any reason, it's returned
struct ReportSegmentUnitsMetadataResponse {
   1: i64 requestId,
   2: list<SegUnitConflict_Thrift> conflicts,
   3: list<shared.SegmentUnitMetadata_Thrift> segUnitsMetadata,
   4: map<i64, set<i64>> whichHAThisVolumeToReport,
   5: map<i64, set<i64>> volumeNotToReportCurrentInstance,
   6: optional map<i64, i32> volumeMaxSnapshotId,
}

struct ReserveVolumeRequest {
   1:i64 requestId,
   2:i64 rootVolumeId,
   3:i64 volumeId,
   4:string name,
   5:i64 volumeSize,
   6:i64 segmentSize,
   7:shared.VolumeType_Thrift volumeType,
   8:i64 accountId,
   9:list<shared.Tag> tags,
   10: bool notCreateAllSegmentAtBegining, // mark create all segment at the beginning
   11: i32 leastSegmentUnitCount, // if not create all segment at the beginning, the least segment unit should be created
   12: bool simpleConfiguration
}

struct ReserveVolumeResponse {
   1:i64 requestId,
   2:map<i32, map<shared.SegmentUnitType_Thrift, list<shared.InstanceIdAndEndPoint_Thrift>>> segIndex2Instances
}

struct LoadVolumeRequest {
    1:i64 accountId,
}
struct LoadVolumeResponse {

}



struct ChangeVolumeStatusFromFixToUnavailableRequest{
    1:i64 requestId,
    2:i64 volumeId,
    3:i64 accountId,
}

struct ChangeVolumeStatusFromFixToUnavailableResponse{
    1:bool changeSucess,
}

struct TAlarmInformation {
    1:string alarmObject,
    2:string alarmName,
    3:string timeStamp,
    4:string alarmLevel,
    5:string description
}

struct TGetAlarmRequest {
    1:i64 requestId,
    2:i64 accountId
}

struct TGetAlarmResponse {
    1:i64 responseId,
    2:list<TAlarmInformation> alarms
}

struct DriverContainerCandidate_Thrift {
	1:string hostName,
	2:i32 port,
	3:i64 sequenceId
}

struct RetrieveARebalanceTaskRequest {
	1:i64 requestId,
	2:bool record
}

struct RetrieveARebalanceTaskResponse {
    1:i64 requestId,
    2:shared.RebalanceTask_Thrift rebalanceTask,
}

struct RecoverDatabaseRequest {
    1: i64 requestId
}
struct RecoverDatabaseResponse {
    1: bool success
}

struct GetServerNodeByIpRequest {
    1: i64 requestId,
    2: string ip,
}

struct GetServerNodeByIpResponse {
    1: i64 responseId,
    2: shared.ServerNode_Thrift serverNode,
}

struct PingPeriodicallyRequest {
    1: i64 requestId,
    2: string serverId,
}

struct PingPeriodicallyResponse {
    1: i64 responseId,
}

exception NoNeedToRebalance_Thrift {
    1: optional string detail
}

exception SegmentNotFoundException_Thrift {
  1: optional string detail
}



//**********for other ***/
exception VolumeBeingCreatedException_Thrift {
   1: optional string detail
}

//********** Create Segment Request ******************************/
struct CreateSegmentUnitRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex,
   4: shared.VolumeType_Thrift volumeType,
   5: shared.CacheType_Thrift cacheType,
   6: shared.SegmentUnitType_Thrift segmentUnitType,
   7: optional shared.SegmentMembership_Thrift initMembership, // the initial membership, used by a new node trying to join an existing group
   8: optional list<i64> initMembers, // the initial members, used by new nodes to create a brand new volume. If initMembership is set too,
   // then initMembership has higher preference to initMembers.
   9: optional binary initSnapshotManagerInBinary, // the initial snapshot manager in binary
   10:optional bool fixVolume,
   11:optional i64 storagePoolId,
   12:optional shared.SegmentUnitRole_Thrift segmentRole,
   13:optional map<shared.InstanceIdAndEndPoint_Thrift,shared.SegmentMembership_Thrift> segmentMembershipMap,
   14:optional shared.SegmentMembership_Thrift srcMembership,
   15:optional shared.CloneType_Thrift cloneType,
   16:optional i32 segmentWrapSize,
   17:i64 requestTimestampMillis,
   18:i64 requestTimeoutMillis,
   19: shared.WtsType_Thrift wtsType,
   20: bool enableLaunchMultiDrivers,
   21: shared.VolumeSource_Thrift volumeSource
}

struct CreateSegmentUnitResponse {
   1: i64 requestId
}

struct CreateSegmentsRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex,
   4: i32 numToCreate,
   5: shared.VolumeType_Thrift volumeType,
   6: shared.CacheType_Thrift cacheType,
   7: optional list<i64> initMembers,
   8: i64 accountId,
   9: i64 domainId,
   10: i64 storagePoolId
}

struct CreateSegmentsResponse {
   1: i64 requestId
}

struct UpdateVolumeLayoutRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex,
   4: i32 numToCreate
}

struct UpdateVolumeLayoutResponse {
   1: i64 requestId,
   2: string volumeLayout
}

struct ReportJustCreatedSegmentUnitRequest {
   1: i64 requestId,
   2: shared.SegmentUnitMetadata_Thrift segUnitMeta
}

struct ReportJustCreatedSegmentUnitResponse {
   1: i64 requestId,
}

struct ReportVolumeInfoRequest {
   1: i64 requestId,
   2: i64 instanceId,
   3: string instanceName,
   4: list<shared.VolumeMetadata_Thrift> volumeMetadatas,
   5: list<shared.VolumeMetadata_Thrift> volumeMetadatasForDelete,
   6: map<i64, i64> totalSegmentUnitMetadataNumber
}

struct ReportVolumeInfoResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadata_Thrift> volumeMetadatasChangeInMaster,
   3: set<i64> notReportThisVolume,
   4: map<i64, i32> volumeIdToSnapshotVersion,
}

//******** End of CreateSegmentUnitRequest *****/

struct ExtendVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 extendSize,
   4: i64 accountId
   5: i64 domainId,
   6: i64 storagePoolId
}

struct ExtendVolumeResponse {
   1: i64 requestId
}

struct MarkVolumesReadWriteRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: set<i64> volumeIds,
   4: shared.ReadWriteType_Thrift readWrite
}

struct MarkVolumesReadWriteResponse {
   1: i64 requestId
}

struct CheckVolumeIsReadOnlyRequest {
   1: i64 requestId,
   2: i64 volumeId
}
struct CheckVolumeIsReadOnlyResponse {
   1: i64 requestId,
   2: i64 volumeId,
   3: bool readOnly
}

struct CreateRoleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: string roleName,
    4: string description,
    5: set<string> apiNames;
}
struct CreateRoleResponse {
    1: i64 requestId,
    2: i64 createdRoleId;
}

struct AssignRolesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 assignedAccountId,
    4: set<i64> roleIds;
}
struct AssignRolesResponse {
    1: i64 requestId;
}

struct UpdateRoleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 roleId,
    4: string roleName,
    5: string description,
    6: set<string> apiNames;
}

struct UpdateRoleResponse {
    1: i64 requestId;
}

struct ListAPIsRequest {
    1: i64 requestId,
    2: i64 accountId;
}

struct ListAPIsResponse {
    1: i64 requestId,
    2: set<shared.APIToAuthorize_Thrift> apis;
}

struct ListRolesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional set<i64> listRoleIds;
}

struct ListRolesResponse {
    1: i64 requestId,
    2: set<shared.Role_Thrift> roles;
}

struct DeleteRolesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: set<i64> roleIds;
}
struct DeleteRolesResponse {
    1: i64 requestId,
    2: set<i64> deletedRoleIds;
}

struct InstanceMaintainRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 instanceId,
    4: i64 durationInMinutes,
    5: string ip
}
struct InstanceMaintainResponse {
    1: i64 requestId
}

struct CancelMaintenanceRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 instanceId
}
struct CancelMaintenanceResponse {
    1: i64 requestId
}

struct InstanceMaintenance_Thrift {
    1: i64 instanceId,
    2: i64 startTime,
    3: i64 endTime,
    4: i64 currentTime,
    5: i64 duration
    6: string ip
}

struct ListInstanceMaintenancesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional list<i64> instanceIds
}
struct ListInstanceMaintenancesResponse {
    1: i64 requestId,
    2: list<InstanceMaintenance_Thrift> instanceMaintenances
}

struct CreateSnapshotVolumeRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:string snapshotName,
    4:string description,
    5:i64 createdTime,
    6:i32 parentId,
    7:i64 accountId,
    8: i64 domainId,
    9: i64 storagePoolId,
    // this field is optional, when console create snapshot id, it does not know the snapshot id and control center will allocate id
    10:optional i32 snapshotId,
    11: optional string newVolumeName,
    12: shared.CloneType_Thrift cloneType,
    13: bool simpleConfiguration,
    14:optional i64 destVolumeId
}
struct CreateSnapshotVolumeResponse {
    1: i64 requestId,
    2: i64 newVolumeId
}

struct LogoutRequest {
    1: i64 requestId,
    2: i64 accountId
}
struct LogoutResponse {
    1: i64 requestId
}

struct GetSegmentSizeResponse {
    1: i64 segmentSize
}

struct VerifyReportStatisticsPermissionRequest {
    1: i64 requestId,
    2: i64 accountId
}
struct VerifyReportStatisticsPermissionResponse {
    1: i64 responseId
}

struct SaveOperationLogsToCSVRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional string accountName,
    4: optional string operationType,
    5: optional string targetType,
    6: optional string targetName,
    7: optional string status,
    8: optional i64 startTime,
    9: optional i64 endTime
}
struct SaveOperationLogsToCSVResponse {
    1: i64 requestId,
    2: binary csvFile
}

struct GetSnapshotsIdByVolumeIdRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 volumeId
}
struct GetSnapshotsIdByVolumeIdResponse {
    1: i64 requestId,
    2: list<i32> snapshotsId,
    3: map<i32, i64> snapshotId2UserDefinedSnapshotIdForOpenStack
}

/** scsi ****/
struct CreateSCSIClientRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: string ip,
    4: i64 driverContainerId
}

struct CreateSCSIClientResponse {
    1: i64 requestId
}

struct DeleteSCSIClientRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<string> ips
}

struct DeleteSCSIClientResponse {
    1: i64 requestId,
    2: map<string, shared.ScsiClientOperationException_Thrift> error
}

struct ListSCSIClientRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: string ip
}

struct ListSCSIClientResponse {
    1: i64 requestId,
    2: list<icshared.SCSIClientDescription_Thrift> clientDescriptions,
    3: string currentIp,
    4: list<icshared.SCSIClientInfo_Thrift> launchVolumesForSCSI,
    5: list<shared.VolumeMetadata_Thrift> unLaunchVolumesForSCSI,
}

// throw this exception when fail to apply or cancel volume access rules in driver
exception FailedToTellDriverAboutAccessRulesException_Thrift {
   1: optional string detail
}

exception CreateRoleNameExistedException_Thrift {
   1: optional string detail
}

//**** end *******/

/**
 * The definition of the service that manages segment membership
 */
service InformationCenter extends shared.DebugConfigurator{
   // Healthy?
   void ping(),
   
   //Shutdown 
   void shutdown(),

    ReportVolumeInfoResponse reportVolumeInfo(1:ReportVolumeInfoRequest request) throws(
                                        1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                        2:shared.ServiceIsNotAvailable_Thrift sina),

    RecoverDatabaseResponse recoverDatabase() throws(
                                    1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                    2:shared.ServiceIsNotAvailable_Thrift sina),

   // Add more exceptions here
   ReportArchivesResponse reportArchives(1:ReportArchivesRequest request) throws(
   							1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
   							2:shared.InvalidGroupException_Thrift ige,
   							3:shared.ServiceIsNotAvailable_Thrift sina,
   							4:shared.InvalidInputException_Thrift iie),

   // Add more exceptions here
   ReportSegmentUnitsMetadataResponse reportSegmentUnitsMetadata(1:ReportSegmentUnitsMetadataRequest request) throws (
   						1:shared.InternalError_Thrift ie,
   						2:shared.ServiceHavingBeenShutdown_Thrift shbsd,
   						3:shared.ServiceIsNotAvailable_Thrift sina),

   ReportSegmentUnitRecycleFailResponse reportSegmentUnitRecycleFail(1:ReportSegmentUnitRecycleFailRequest request) throws (
                        1:shared.InternalError_Thrift ie,
                        2:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        3:shared.ServiceIsNotAvailable_Thrift sina), 

   CreateSegmentsResponse createSegments(1:CreateSegmentsRequest request) throws (
                                                1:shared.NotEnoughSpaceException_Thrift nese,
                                                2:shared.SegmentExistingException_Thrift seet,
                                                3:shared.NoMemberException_Thrift nmet,
                                                4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                5:shared.ServiceIsNotAvailable_Thrift sina,
                                                6:shared.EndPointNotFoundException_Thrift epnfe,
                                                7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                8:shared.NetworkErrorException_Thrift nme
                                                ),

   UpdateVolumeLayoutResponse updateVolumeLayout(1:UpdateVolumeLayoutRequest request) throws (
                                                   1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                   2:shared.ServiceIsNotAvailable_Thrift sina
                                                   ),

   icshared.GetSegmentListResponse getSegmentList(1:icshared.GetSegmentListRequest request) throws (
                                        1:shared.InternalError_Thrift ie,
                                        2:shared.InvalidInputException_Thrift iie,
                                        3:shared.NotEnoughSpaceException_Thrift nese,
                                        4:shared.VolumeNotFoundException_Thrift vnfe,
                                        5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                        6:shared.ServiceIsNotAvailable_Thrift sina),

   icshared.GetSegmentResponse getSegment(1:icshared.GetSegmentRequest request) throws (
                                        1:shared.InternalError_Thrift ie,
                                        2:shared.VolumeNotFoundException_Thrift vnfe,
                                        3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                        4:shared.ServiceIsNotAvailable_Thrift sina),

   icshared.OrphanVolumeResponse listOrphanVolume(1:icshared.OrphanVolumeRequest request) throws (
                                                                                            1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2:shared.ServiceIsNotAvailable_Thrift sina),
     
   icshared.GetVolumeResponse getVolumeNotDeadByName(1:icshared.GetVolumeRequest request) throws (
      					1:shared.InternalError_Thrift ie,
      					2:shared.InvalidInputException_Thrift iie,
      					3:shared.NotEnoughSpaceException_Thrift nese,
      					4:shared.VolumeNotFoundException_Thrift vnfe,
      					5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
      					6:shared.ServiceIsNotAvailable_Thrift sina),

   icshared.ListArchivesResponse_Thrift listArchives(1:icshared.ListArchivesRequest_Thrift request) throws (
                        1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        2:shared.ServiceIsNotAvailable_Thrift sina),

   icshared.ListArchivesAfterFilterResponse_Thrift ListArchivesAfterFilter(1:icshared.ListArchivesAfterFilterRequest_Thrift request)
                           throws (
                           1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                           2:shared.ServiceIsNotAvailable_Thrift sina),

   icshared.GetArchiveResponse_Thrift getArchive(1:icshared.GetArchiveRequest_Thrift request) throws (
                        1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        2:shared.ServiceIsNotAvailable_Thrift sina),

   icshared.GetArchivesResponse_Thrift getArchives(1:icshared.GetArchivesRequest_Thrift request) throws (
                        1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        2:shared.ServiceIsNotAvailable_Thrift sina),
   icshared.GetDriversResponse_Thrift getDrivers(1: icshared.GetDriversRequest_Thrift request) throws (
                           1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                           2:shared.VolumeNotFoundException_Thrift vnfe,
                           3:shared.ServiceIsNotAvailable_Thrift sina),

                        
   LoadVolumeResponse loadVolume(1:LoadVolumeRequest request) throws (
   						1:shared.LoadVolumeException_Thrift lve),

   //********** StoragePool Qos end************/
   icshared.ReportDriverMetadataResponse reportDriverMetadata(1:icshared.ReportDriverMetadataRequest request) throws (1:shared.ServiceIsNotAvailable_Thrift sina),
   
    shared.ChangeDriverBoundVolumeResponse changeDriverBoundVolume(1:shared.ChangeDriverBoundVolumeRequest request) throws (
                                                                                                    1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
   																									2:shared.ServiceIsNotAvailable_Thrift sina),

   shared.ListVolumeAccessRulesByVolumeIdsResponse listVolumeAccessRulesByVolumeIds(1:shared.ListVolumeAccessRulesByVolumeIdsRequest request) throws (
                               1:shared.ServiceIsNotAvailable_Thrift sina),

   shared.CancelDriversRulesResponse cancelDriversRules(1:shared.CancelDriversRulesRequest request) throws (
                               1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                               2:shared.ServiceIsNotAvailable_Thrift sina),

   shared.ListIscsiAccessRulesByDriverKeysResponse listIscsiAccessRulesByDriverKeys(1:shared.ListIscsiAccessRulesByDriverKeysRequest request) throws (
                               1:shared.ServiceIsNotAvailable_Thrift sina),

   TGetAlarmResponse getAlarms(1:TGetAlarmRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2:shared.InvalidInputException_Thrift iie,
                                                                      3:shared.ServiceIsNotAvailable_Thrift sina),

   TGetAlarmResponse getAlarmsFromSyslog(1:TGetAlarmRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2:shared.InvalidInputException_Thrift iie,
                                                                      3:shared.ServiceIsNotAvailable_Thrift sina),

   ReportSegmentUnitCloneFailResponse reportCloneFailed(1:ReportSegmentUnitCloneFailRequest request) throws (
                                                                      1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                      3:shared.VolumeNotFoundException_Thrift vnf),

   RetrieveARebalanceTaskResponse retrieveARebalanceTask(1: RetrieveARebalanceTaskRequest request) throws (
                                                                      1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                      3: NoNeedToRebalance_Thrift nntr),

   bool discardRebalanceTask(1:i64 requestTaskId) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                          2: shared.ServiceIsNotAvailable_Thrift sina),

   ChangeVolumeStatusFromFixToUnavailableResponse changeVolumeStatusFromFixToUnavailable(1:ChangeVolumeStatusFromFixToUnavailableRequest request) throws(1:shared.InternalError_Thrift ie
                                                                                                                   2:shared.VolumeNotFoundException_Thrift vnf,
                                                                                                                   3:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                   4:shared.ServiceIsNotAvailable_Thrift sina),

   shared.ReportServerNodeInfoResponse_Thrift reportServerNodeInfo(1:shared.ReportServerNodeInfoRequest_Thrift request) throws(1:shared.ServiceIsNotAvailable_Thrift sin,
                                                                                        2:shared.ServiceHavingBeenShutdown_Thrift shbs),

   shared.TurnOffAllDiskLightByServerIdResponse_Thrift turnOffAllDiskLightByServerId(1:shared.TurnOffAllDiskLightByServerIdRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                           2:shared.ServiceIsNotAvailable_Thrift sina),


   shared.GetIOLimitationResponse_Thrift getIOLimitationsInOneDriverContainer(1:shared.GetIOLimitationRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                        2:shared.ServiceIsNotAvailable_Thrift sina),

   GetServerNodeByIpResponse getServerNodeByIp(1:GetServerNodeByIpRequest request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                           2:shared.ServiceIsNotAvailable_Thrift sina),

   PingPeriodicallyResponse pingPeriodically(1:PingPeriodicallyRequest request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                        2:shared.ServiceIsNotAvailable_Thrift sina),

icshared.CreateAccessRuleOnNewVolumeResponse createAccessRuleOnNewVolume(1:icshared.CreateAccessRuleOnNewVolumeRequest request) throws ( 1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                                         2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                                         3:shared.InvalidInputException_Thrift iie,
                                                                                                                                         4:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                                                                         5:shared.VolumeNameExistedException_Thrift vnee),
icshared.DeleteAccessRuleOnOldVolumeResponse deleteAccessRuleOnOldVolume(1:icshared.DeleteAccessRuleOnOldVolumeRequest request) throws ( 1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                                         2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                                         3:shared.InvalidInputException_Thrift iie,
                                                                                                                                         4:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                                                                         5:shared.VolumeNameExistedException_Thrift vnee),

/** for other ***/
   // Store the create volume request and a job will pick up the request and fulfill the request asynchronously
    icshared.CreateVolumeResponse createVolume(1:icshared.CreateVolumeRequest request) throws (
                        1:shared.NotEnoughSpaceException_Thrift nese,
                        2:shared.NetworkErrorException_Thrift nme,
                        3:shared.InvalidInputException_Thrift iie,
                        4:shared.AccessDeniedException_Thrift ade,
                        5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        6:shared.VolumeSizeNotMultipleOfSegmentSize_Thrift vsnmogss,
                        7:shared.VolumeExistingException_Thrift vee,
                        8:shared.VolumeNameExistedException_Thrift vnee,
                        9:shared.BadLicenseTokenException_Thrift blte,
                        10:shared.UselessLicenseException_Thrift ule,
                        11:shared.NotEnoughLicenseTokenException_Thrift nelte,
                        12:shared.ServiceIsNotAvailable_Thrift sina,
                        13:shared.StoragePoolNotExistInDoaminException_Thrift sneide,
                        14:shared.DomainNotExistedException_Thrift dnee,
                        15:shared.StoragePoolNotExistedException_Thrift spnee,
                        16:shared.DomainIsDeletingException_Thrift dide,
                        17:shared.StoragePoolIsDeletingException_Thrift spide,
                        18:shared.NotEnoughGroupException_Thrift nege,
                        19:shared.PermissionNotGrantException_Thrift png,
                        20:shared.AccountNotFoundException_Thrift anf,
                        21:shared.EndPointNotFoundException_Thrift epnf,
                        22:shared.TooManyEndPointFoundException_Thrift tmepfe,
                        23:shared.LicenseException_Thrift le,
                        24:shared.VolumeNotFoundException_Thrift vnfe,
                        25:shared.NotEnoughNormalGroupException_Thrift nenge,
                        26:shared.UnsupportedCacheTypeException_Thrift uctet,
                        27:shared.UnsupportedWTSTypeException_Thrift uwtstet),

   icshared.DeleteVolumeResponse deleteVolume(1:icshared.DeleteVolumeRequest request) throws (
                        1:shared.AccessDeniedException_Thrift ade,
                        2:shared.NotEnoughSpaceException_Thrift nese,
                        3:shared.VolumeNotFoundException_Thrift vnfe,
                        4:shared.VolumeBeingDeletedException_Thrift vbde,
                        5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        6:shared.VolumeInExtendingException_Thrift vee,
                        7:shared.LaunchedVolumeCannotBeDeletedException_Thrift lvcbde,
                        8:shared.ServiceIsNotAvailable_Thrift sina,
                        9:shared.VolumeUnderOperationException_Thrift vuoe,
                        10:shared.SnapshotDeletingException_Thrift sde,
                        11:shared.SnapshotCreatingException_Thrift sce,
                        12:shared.SnapshotRollingBackException_Thrift srbe,
                        13:shared.DriverLaunchingException_Thrift dle,
                        14:shared.DriverUnmountingException_Thrift due,
                        15:shared.VolumeDeletingException_Thrift vde,
                        16:shared.VolumeWasRollbackingException_Thrift vwre,
                        17:shared.InvalidInputException_Thrift iie,
                        18:shared.VolumeIsCloningException_Thrift vic,
                        19:shared.ResourceNotExistsException_Thrift rne,
                        20:shared.PermissionNotGrantException_Thrift png,
                        21:shared.AccountNotFoundException_Thrift anf,
                        22:shared.VolumeIsCopingException_Thrift vice,
                        23:shared.ExistsDriverException_Thrift ede,
                        24:shared.TooManyEndPointFoundException_Thrift tmepfe,
                        25:shared.NetworkErrorException_Thrift nme,
                        26:shared.EndPointNotFoundException_Thrift epnfe,
                        27:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe,
                        28:shared.VolumeIsBeginMovedException_Thrift vibme,
                        29:shared.VolumeIsMovingException_Thrift vime),

   CreateSegmentUnitResponse createSegmentUnit(1:CreateSegmentUnitRequest request) throws (
                        1:shared.NotEnoughSpaceException_Thrift nese,
                        2:shared.SegmentExistingException_Thrift seet,
                        3:shared.SegmentUnitBeingDeletedException_Thrift sbet,
                        4:shared.NoMemberException_Thrift nmet,
                        5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        6:shared.InternalError_Thrift ie,
                        7:shared.ServiceIsNotAvailable_Thrift sina),

   shared.CreateSnapshotResponse createSnapshot(1:shared.CreateSnapshotRequest request) throws (
                        1:shared.NotEnoughSpaceException_Thrift nese,
                        2:shared.SnapshotCountReachMaxException_Thrift seet,
                        3:shared.SnapshotNameExistException_Thrift sbet,
                        4:shared.ServiceIsNotAvailable_Thrift sina,
                        5:shared.VolumeNotFoundException_Thrift vnfe,
                        6:shared.VolumeUnderOperationException_Thrift vuoe,
                        7:shared.InvalidInputException_Thrift iie,
                        8:shared.VolumeNotAvailableException_Thrift vnae,
                        9:shared.NoDriverLaunchException_Thrift ndle,
                        10:shared.VolumeWasRollbackingException_Thrift vwre,
                        11:shared.SnapshotDeletingException_Thrift sde,
                        12:shared.SnapshotCreatingException_Thrift sce,
                        13:shared.SnapshotRollingBackException_Thrift srbe,
                        14:shared.DriverLaunchingException_Thrift dle,
                        15:shared.DriverUnmountingException_Thrift due,
                        16:shared.VolumeDeletingException_Thrift vde,
                        17:shared.SnapshotExistException_Thrift see,
                        18:shared.PermissionNotGrantException_Thrift png,
                        19:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        20:shared.AccountNotFoundException_Thrift anf,
                        21:shared.AccessDeniedException_Thrift ade,
                        22:shared.NetworkErrorException_Thrift nee,
                        23:shared.EndPointNotFoundException_Thrift epnfe,
                        24:shared.TooManyEndPointFoundException_Thrift tmepfe,
                        25:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe
                        ),

   shared.DeleteSnapshotResponse deleteSnapshot(1:shared.DeleteSnapshotRequest request) throws (
                        1:shared.ServiceIsNotAvailable_Thrift sina,
                        2:shared.CoordinatorSyncException_Thrift cse,
                        3:shared.InvalidInputException_Thrift iie,
                        4:shared.VolumeUnderOperationException_Thrift vuoe,
                        5:shared.SnapshotBeMountedException_Thrift sbme,
                        6:shared.SnapshotDeletingException_Thrift sde,
                        7:shared.SnapshotCreatingException_Thrift sce,
                        8:shared.SnapshotRollingBackException_Thrift srbe,
                        9:shared.DriverLaunchingException_Thrift dle,
                        10:shared.DriverUnmountingException_Thrift due,
                        11:shared.VolumeDeletingException_Thrift vde,
                        12:shared.VolumeWasRollbackingException_Thrift vwre,
                        13:shared.PermissionNotGrantException_Thrift png,
                        19:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        20:shared.AccountNotFoundException_Thrift anf,
                        21:shared.AccessDeniedException_Thrift ade,
                        22:shared.VolumeNotFoundException_Thrift vnfe,
                        23:shared.NetworkErrorException_Thrift nee,
                        24:shared.EndPointNotFoundException_Thrift epnfe,
                        25:shared.TooManyEndPointFoundException_Thrift tmepfe,
                        26:shared.SnapshotIsInCloningException_Thrift siice
                        ),

   shared.RollbackFromSnapshotResponse rollbackFromSnapshot(1:shared.RollbackFromSnapshotRequest request) throws (
                                                                      1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2:shared.SnapshotNotFoundException_Thrift snfe,
                                                                      3:shared.VolumeNotFoundException_Thrift vnfe,
                                                                      4:shared.ServiceIsNotAvailable_Thrift sina,
                                                                      5:shared.AccessDeniedException_Thrift ade,
                                                                      6:shared.VolumeUnderOperationException_Thrift vuoe,
                                                                      7:shared.SnapshotBeMountedException_Thrift sbme,
                                                                      8:shared.VolumeWasRollbackingException_Thrift vwre,
                                                                      9:shared.SnapshotDeletingException_Thrift sde,
                                                                      10:shared.SnapshotCreatingException_Thrift sce,
                                                                      11:shared.SnapshotRollingBackException_Thrift srbe,
                                                                      12:shared.DriverLaunchingException_Thrift dle,
                                                                      13:shared.DriverUnmountingException_Thrift due,
                                                                      14:shared.VolumeDeletingException_Thrift vde,
                                                                      15:shared.LaunchedVolumeCannotRollbackException_Thrift lvce,
                                                                      16:shared.PermissionNotGrantException_Thrift png,
                                                                      17:shared.InvalidInputException_Thrift iie,
                                                                      18:shared.NetworkErrorException_Thrift nee,
                                                                      19:shared.EndPointNotFoundException_Thrift epnfe,
                                                                      20:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                      21:shared.AccountNotFoundException_Thrift anfe
                                                                      ),

  icshared.CloneVolumeResponse cloneVolume(1:icshared.CloneVolumeRequest request) throws (
                        1:shared.NotEnoughSpaceException_Thrift nese,
                        2:shared.AccessDeniedException_Thrift ade,
                        3:shared.VolumeNotFoundException_Thrift vnfe,
                        4:shared.SnapshotNotFoundException_Thrift snfe,
                        5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        6:shared.VolumeNotAvailableException_Thrift vane,
                        7:shared.VolumeNameExistedException_Thrift vnee,
                        8:shared.InvalidInputException_Thrift iie,
                        9:shared.BadLicenseTokenException_Thrift blte,
                        10:shared.UselessLicenseException_Thrift ule,
                        11:shared.NotEnoughLicenseTokenException_Thrift nelte,
                        12:shared.ServiceIsNotAvailable_Thrift sina,
                        13:shared.VolumeWasRollbackingException_Thrift vwre,
                        14:shared.StoragePoolNotExistInDoaminException_Thrift spne,
                        15:shared.DomainNotExistedException_Thrift dnee,
                        16:shared.StoragePoolNotExistedException_Thrift spnee,
                        17:shared.DomainIsDeletingException_Thrift dide,
                        18:shared.StoragePoolIsDeletingException_Thrift spide,
                        19:shared.NotEnoughGroupException_Thrift nege,
                        20:shared.PermissionNotGrantException_Thrift png,
                        21:shared.AccountNotFoundException_Thrift anf,
                        22:shared.NotEnoughNormalGroupException_Thrift agnfe,
                        23:shared.EndPointNotFoundException_Thrift epnfe,
                        24:shared.TooManyEndPointFoundException_Thrift tmepfe,
                        25:shared.NetworkErrorException_Thrift nme,
                        26:shared.LicenseException_Thrift le,
                        27:shared.VolumeExistingException_Thrift vee,
                        28:shared.RootVolumeBeingDeletedException_Thrift rvbde,
                        29:shared.RootVolumeNotFoundException_Thrift rvnfe,
                        30:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe
                       ),


   shared.LaunchDriverResponse_Thrift launchDriver(1:shared.LaunchDriverRequest_Thrift request) throws (1:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                              2:shared.VolumeNotAvailableException_Thrift vane,
                                                                                              3:shared.TooManyDriversException_Thrift tmde,
                                                                                              4:shared.NotRootVolumeException_Thrift nrve,
                                                                                              5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              6:shared.VolumeBeingDeletedException_Thrift vbde,
                                                                                              7:shared.DriverTypeConflictException_Thrift dtce,
                                                                                              8:shared.AccessDeniedException_Thrift ade,
                                                                                              9:shared.InvalidInputException_Thrift iie,
                                                                                              10:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              11:shared.VolumeUnderOperationException_Thrift vuoe,
                                                                                              12:shared.SnapshotDeletingException_Thrift sde,
                                                                                              13:shared.SnapshotCreatingException_Thrift sce,
                                                                                              14:shared.SnapshotRollingBackException_Thrift srbe,
                                                                                              15:shared.DriverLaunchingException_Thrift dle,
                                                                                              16:shared.DriverUnmountingException_Thrift due,
                                                                                              17:shared.VolumeDeletingException_Thrift vde,
                                                                                              18:shared.VolumeWasRollbackingException_Thrift vwre,
                                                                                              19:shared.SystemMemoryIsNotEnough_Thrift smie,
                                                                                              20:shared.DriverAmountAndHostNotFit_Thrift dahn,
                                                                                              21:shared.DriverHostCannotUse_Thrift dhcu,
                                                                                              22:shared.DriverIsUpgradingException_Thrift diu,
                                                                                              23:shared.PermissionNotGrantException_Thrift png,
                                                                                              24:shared.AccountNotFoundException_Thrift anf,
                                                                                              25:shared.DriverTypeIsConflictException_Thrift dtic,
                                                                                              26:shared.DriverNameExistsException_Thrift dneet,
                                                                                              27:shared.ExistsDriverException_Thrift ed,
                                                                                              28:shared.VolumeLaunchMultiDriversException_Thrift vlmd,
                                                                                              29:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                              30:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                              31:shared.NetworkErrorException_Thrift nme,
                                                                                              32:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe,
                                                                                              33:shared.SystemCpuIsNotEnough_Thrift scine,
                                                                                              34:shared.UnknownIPV4HostException_Thrift ui4he,
                                                                                              35:shared.UnknownIPV6HostException_Thrift ui6he
                                                                                              ),

    shared.UmountDriverResponse_Thrift umountDriver(1:shared.UmountDriverRequest_Thrift request) throws (1:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                           2:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                           3:shared.NoDriverLaunchException_Thrift ndle
                                                                                           4:shared.ExistsClientException_Thrift ece,
                                                                                           5:shared.DriverIsLaunchingException_Thrift dile,
                                                                                           6:shared.AccessDeniedException_Thrift ade,
                                                                                           7:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                           8:shared.SnapshotDeletingException_Thrift sde,
                                                                                           9:shared.SnapshotCreatingException_Thrift sce,
                                                                                           10:shared.SnapshotRollingBackException_Thrift srbe,
                                                                                           11:shared.DriverLaunchingException_Thrift dle,
                                                                                           12:shared.DriverUnmountingException_Thrift due,
                                                                                           13:shared.VolumeDeletingException_Thrift vde,
                                                                                           14:shared.VolumeUnderOperationException_Thrift vuoe,
                                                                                           15:shared.InvalidInputException_Thrift iie,
                                                                                           16:shared.DriverIsUpgradingException_Thrift diu,
                                                                                           17:shared.TransportException_Thrift tet,
                                                                                           18:shared.DriverContainerIsINCException_Thrift dcii,
                                                                                           19:shared.PermissionNotGrantException_Thrift png,
                                                                                           20:shared.AccountNotFoundException_Thrift anf,
                                                                                           29:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                           30:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                           31:shared.NetworkErrorException_Thrift nme),

    shared.GetPerformanceFromPYMetricsResponse_Thrift pullPerformanceFromPYMetrics(1:shared.GetPerformanceParameterRequest_Thrift request) throws (
                                                                                            1:shared.VolumeHasNotBeenLaunchedException_Thrift vhnble,
                                                                                            2:shared.ReadPerformanceParameterFromFileException_Thrift gppffe,
                                                                                            3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                            4:shared.ServiceHavingBeenShutdown_Thrift shbs),

   shared.GetStoragePerformanceFromPYMetricsResponse_Thrift pullStoragePerformanceFromPYMetrics(1:shared.GetStoragePerformanceParameterRequest_Thrift request) throws (
                               1:shared.VolumeHasNotBeenLaunchedException_Thrift vhnble,
                               2:shared.ReadPerformanceParameterFromFileException_Thrift gppffe,
                               3:shared.ServiceIsNotAvailable_Thrift sina,
                               4:shared.InvalidInputException_Thrift iie,
                               5:shared.ServiceHavingBeenShutdown_Thrift shbs),

       shared.GetPerformanceResponse_Thrift pullPerformanceParameter(1:shared.GetPerformanceParameterRequest_Thrift request) throws (
                                  1:shared.VolumeHasNotBeenLaunchedException_Thrift vhnble,
                                  2:shared.ReadPerformanceParameterFromFileException_Thrift gppffe,
                                  3:shared.ServiceIsNotAvailable_Thrift sina,
                                  4:shared.ServiceHavingBeenShutdown_Thrift shbs),

    ExtendVolumeResponse extendVolume(1:ExtendVolumeRequest request) throws (
                               1:shared.NotEnoughSpaceException_Thrift nese,
                               2:shared.EndPointNotFoundException_Thrift epnfe,
                               3:shared.InvalidInputException_Thrift iie,
                               4:shared.AccessDeniedException_Thrift ade,
                               5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                               6:shared.VolumeSizeNotMultipleOfSegmentSize_Thrift vsnmogss,
                               7:shared.RootVolumeBeingDeletedException_Thrift rvde,
                               8:shared.RootVolumeNotFoundException_Thrift rvnfe,
                               9:shared.ServiceIsNotAvailable_Thrift sina,
                               10:shared.VolumeWasRollbackingException_Thrift vwre,
                               11:shared.NotEnoughGroupException_Thrift nege,
                               12:shared.VolumeIsCloningException_Thrift vic,
                               13:shared.PermissionNotGrantException_Thrift png,
                               14:shared.AccountNotFoundException_Thrift anf,
                               15:shared.TooManyEndPointFoundException_Thrift tmepfe,
                               16:shared.NetworkErrorException_Thrift nme,
                               17:shared.DomainNotExistedException_Thrift dnee,
                               18:shared.NotEnoughLicenseTokenException_Thrift nelte,
                               19:shared.LicenseException_Thrift le,
                               20:shared.UselessLicenseException_Thrift ule,
                               21:shared.VolumeNotFoundException_Thrift vnfe,
                               22:shared.BadLicenseTokenException_Thrift blte,
                               23:shared.VolumeIsCopingException_Thrift vice,
                               24:shared.VolumeExistingException_Thrift vee,
                               25:shared.StoragePoolNotExistedException_Thrift spnee,
                               26:shared.NotEnoughNormalGroupException_Thrift agnfe,
                               27:shared.StoragePoolNotExistInDoaminException_Thrift spnede,
                               28:shared.DomainIsDeletingException_Thrift dide,
                               29:shared.StoragePoolIsDeletingException_Thrift spide,
                               30:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe,
                               31:shared.VolumeNotAvailableException_Thrift vnae
                               ),

    shared.ApplyVolumeAccessRulesResponse applyVolumeAccessRules(1:shared.ApplyVolumeAccessRulesRequest request) throws (1: shared.VolumeNotFoundException_Thrift vnfe,
                                                                                                                           2: shared.VolumeBeingDeletedException_Thrift vbde,
                                                                                                                           3: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                           4: FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                                                                                                                           5:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                           6: shared.ApplyFailedDueToVolumeIsReadOnlyException_Thrift afdtviro,
                                                                                                                           7:shared.PermissionNotGrantException_Thrift png,
                                                                                                                           8:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                           9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                           10:shared.NetworkErrorException_Thrift nme,
                                                                                                                           11:shared.AccessDeniedException_Thrift ade,
                                                                                                                           12:shared.InvalidInputException_Thrift iie
                                                                                                                           ),

    shared.CancelVolumeAccessRulesResponse cancelVolumeAccessRules(1:shared.CancelVolumeAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                            2: FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                                                                                                                            3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                            4:shared.AccessRuleNotApplied_Thrift arna,
                                                                                                                            5:shared.PermissionNotGrantException_Thrift png,
                                                                                                                            6:shared.AccountNotFoundException_Thrift anfe,
                                                                                                                            7:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                                                            8:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                            9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                            10:shared.NetworkErrorException_Thrift nme,
                                                                                                                            11:shared.AccessDeniedException_Thrift ade,
                                                                                                                            12:shared.InvalidInputException_Thrift iie
                                                                                                                            ),

   shared.ApplyVolumeAccessRuleOnVolumesResponse applyVolumeAccessRuleOnVolumes(1:shared.ApplyVolumeAccessRuleOnVolumesRequest request) throws (
                               1:shared.VolumeNotFoundException_Thrift vnfe,
                               2:shared.VolumeBeingDeletedException_Thrift vbde,
                               3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                               4:shared.ServiceIsNotAvailable_Thrift sina,
                               5:shared.ApplyFailedDueToVolumeIsReadOnlyException_Thrift afdtviro,
                               6:shared.AccessRuleUnderOperation_Thrift aruot,
                               7:shared.AccessRuleNotFound_Thrift arnft
                               8:shared.PermissionNotGrantException_Thrift png,
                               9:shared.AccountNotFoundException_Thrift anf,
                               10:shared.EndPointNotFoundException_Thrift epnfe,
                               11:shared.TooManyEndPointFoundException_Thrift tmepfe,
                               12:shared.NetworkErrorException_Thrift nme),

   shared.CancelVolAccessRuleAllAppliedResponse cancelVolAccessRuleAllApplied(1:shared.CancelVolAccessRuleAllAppliedRequest request) throws (
                               1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                               2:shared.ServiceIsNotAvailable_Thrift sina,
                               3:shared.AccessRuleNotApplied_Thrift arna,
                               4:shared.AccessRuleUnderOperation_Thrift aruot,
                               5:shared.AccessRuleNotFound_Thrift arnft,
                               6:shared.PermissionNotGrantException_Thrift png,
                               7:shared.AccountNotFoundException_Thrift anf,
                               8:shared.EndPointNotFoundException_Thrift epnfe,
                               9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                               10:shared.NetworkErrorException_Thrift nme),

    shared.DeleteVolumeAccessRulesResponse deleteVolumeAccessRules(1:shared.DeleteVolumeAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                            2: FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                                                                                                                            3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                            4:shared.PermissionNotGrantException_Thrift png,
                                                                                                                            5:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                            6:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                            7:shared.NetworkErrorException_Thrift nme),

    shared.ListVolumeAccessRulesResponse listVolumeAccessRules(1:shared.ListVolumeAccessRulesRequest request) throws (1: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                      2: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                      3:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                      4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                      5:shared.NetworkErrorException_Thrift nme),

    icshared.ListAllSnapshotsResponse listAllSnapshots(1:icshared.ListAllSnapshotsRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                           2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                           3: shared.ParametersIsErrorException_Thrift piee,
                                                                                                           4:shared.PermissionNotGrantException_Thrift png,
                                                                                                           5: shared.AccountNotFoundException_Thrift anf,
                                                                                                           6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                           7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                           8:shared.NetworkErrorException_Thrift nme),

    GetSnapshotsIdByVolumeIdResponse getSnapshotsIdByVolumeId(1:GetSnapshotsIdByVolumeIdRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                           2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                           3: shared.ParametersIsErrorException_Thrift piee,
                                                                                                           4: shared.PermissionNotGrantException_Thrift png,
                                                                                                           5: shared.AccountNotFoundException_Thrift anf,
                                                                                                           6: shared.AccessDeniedException_Thrift ade,
                                                                                                           7: shared.VolumeNotFoundException_Thrift vnfe),

  icshared.ListAllDriversResponse listAllDrivers(1:icshared.ListAllDriversRequest request) throws (1: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                   2: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                   3: shared.ParametersIsErrorException_Thrift piee,
                                                                                                   4: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                   5: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                   6: shared.NetworkErrorException_Thrift nme),

  shared.GetVolumeAccessRulesResponse getVolumeAccessRules(1:shared.GetVolumeAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                 3: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                 4: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                 5: shared.NetworkErrorException_Thrift nme),

  shared.CreateVolumeAccessRulesResponse createVolumeAccessRules(1:shared.CreateVolumeAccessRulesRequest request) throws (
                        1:shared.VolumeAccessRuleDuplicate_Thrift vard,
                        2:shared.InvalidInputException_Thrift iie,
                        3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        4:shared.ServiceIsNotAvailable_Thrift sina,
                        5:shared.PermissionNotGrantException_Thrift png,
                        6: shared.EndPointNotFoundException_Thrift epnfe,
                        7: shared.TooManyEndPointFoundException_Thrift tmepfe,
                        8: shared.NetworkErrorException_Thrift nme,
                        9: shared.AccountNotFoundException_Thrift anfe
                        ),

  shared.GetAppliedVolumesResponse getAppliedVolumes(1: shared.GetAppliedVolumesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                            2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                            3:shared.PermissionNotGrantException_Thrift png,
                                                                                                            4: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                            5: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                            6: shared.NetworkErrorException_Thrift nme)
/* iscsi access rules */
  shared.ApplyIscsiAccessRulesResponse applyIscsiAccessRules(1:shared.ApplyIscsiAccessRulesRequest request) throws (1: shared.IscsiNotFoundException_Thrift vnfe,
                                                                                                                      2: shared.IscsiBeingDeletedException_Thrift vbde,
                                                                                                                      3: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                      4: FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                                                                                                                      5: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                      6: shared.ApplyFailedDueToConflictException_Thrift afdtviro,
                                                                                                                      7: shared.PermissionNotGrantException_Thrift png,
                                                                                                                      8: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                      9: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                      10: shared.NetworkErrorException_Thrift nme,
                                                                                                                      11: shared.AccountNotFoundException_Thrift anfe,
                                                                                                                      12: shared.AccessDeniedException_Thrift ade
                                                                                                                      ),

  shared.CancelIscsiAccessRulesResponse cancelIscsiAccessRules(1:shared.CancelIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                        2: FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                                                                                                                        3: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                        4: shared.AccessRuleNotApplied_Thrift arna,
                                                                                                                        5:shared.PermissionNotGrantException_Thrift png,
                                                                                                                        6: shared.AccountNotFoundException_Thrift anfe,
                                                                                                                        7: shared.AccessDeniedException_Thrift ade,
                                                                                                                        8: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                        9: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                        10: shared.NetworkErrorException_Thrift nme
                                                                                                                        ),

  shared.ApplyIscsiAccessRuleOnIscsisResponse applyIscsiAccessRuleOnIscsis(1:shared.ApplyIscsiAccessRuleOnIscsisRequest request) throws (
                               1:shared.IscsiNotFoundException_Thrift vnfe,
                               2:shared.IscsiBeingDeletedException_Thrift vbde,
                               3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                               4:shared.ServiceIsNotAvailable_Thrift sina,
                               5:shared.ApplyFailedDueToConflictException_Thrift afdtviro,
                               6:shared.IscsiAccessRuleUnderOperation_Thrift iaruo,
                               7:shared.IscsiAccessRuleNotFound_Thrift iarnf,
                               8: shared.EndPointNotFoundException_Thrift epnfe,
                               9: shared.TooManyEndPointFoundException_Thrift tmepfe,
                               10: shared.NetworkErrorException_Thrift nme
                                ),

  shared.CancelIscsiAccessRuleAllAppliedResponse cancelIscsiAccessRuleAllApplied(1:shared.CancelIscsiAccessRuleAllAppliedRequest request) throws (
                               1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                               2:shared.ServiceIsNotAvailable_Thrift sina,
                               3:shared.AccessRuleNotApplied_Thrift arna,
                               4:shared.IscsiAccessRuleUnderOperation_Thrift iaruo,
                               5:shared.IscsiAccessRuleNotFound_Thrift iarnf,
                               6: shared.EndPointNotFoundException_Thrift epnfe,
                               7: shared.TooManyEndPointFoundException_Thrift tmepfe,
                               8: shared.NetworkErrorException_Thrift nme
                               ),

  shared.DeleteIscsiAccessRulesResponse deleteIscsiAccessRules(1:shared.DeleteIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                         2: FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                                                                                                                         3: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                         4:shared.PermissionNotGrantException_Thrift png,
                                                                                                                         5:shared.AccountNotFoundException_Thrift anfe,
                                                                                                                         6: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                         7: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                         8: shared.NetworkErrorException_Thrift nee
                                                                                                                         ),

  shared.ListIscsiAccessRulesResponse listIscsiAccessRules(1:shared.ListIscsiAccessRulesRequest request) throws (1: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                 2: shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                 3: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                 4: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                 5: shared.NetworkErrorException_Thrift nee
                                                                                                                ),

  shared.GetIscsiAccessRulesResponse getIscsiAccessRules(1:shared.GetIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                              2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                              3: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                              4: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                              5: shared.NetworkErrorException_Thrift nee
                                                                                                              ),
  shared.ReportIscsiAccessRulesResponse reportIscsiAccessRules(1:shared.ReportIscsiAccessRulesRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                ),

  shared.GetAppliedIscsisResponse getAppliedIscsis(1: shared.GetAppliedIscsisRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                      2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                      3: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                      4: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                      5: shared.NetworkErrorException_Thrift nee
                                                                                                      ),

  shared.CreateIscsiAccessRulesResponse createIscsiAccessRules(1:shared.CreateIscsiAccessRulesRequest request) throws (
                                    1:shared.IscsiAccessRuleDuplicate_Thrift vard,
                                    2:shared.IscsiAccessRuleFormatError_Thrift iarft,
                                    3:shared.InvalidInputException_Thrift iie,
                                    4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                    5:shared.ServiceIsNotAvailable_Thrift sina,
                                    6:shared.PermissionNotGrantException_Thrift png,
                                    7:shared.ChapSameUserPasswdError_Thrift csur,
                                    8: shared.AccountNotFoundException_Thrift anfe,
                                    9: shared.EndPointNotFoundException_Thrift epnfe,
                                    10: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                    11: shared.NetworkErrorException_Thrift nee
                                    ),

  shared.GenericLicenseSequenceNumberResponse_Thrift genericLicenseSequenceNumber_Thrift(1:shared.GenericLicenseSequenceNumberRequest_Thrift request) throws (
                                                                              1:shared.GenericException_Thrift ge,
                                                                              2:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                              3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                              4:shared.PermissionNotGrantException_Thrift png,
                                                                              5:shared.AccountNotFoundException_Thrift anfe
                                                                              ),

  shared.InstallLicenseResponse_Thrift installLicense_Thrift(1:shared.InstallLicenseRequest_Thrift request) throws (
                                                                              1:shared.InvalidLicenseFileException_Thrift ilfe,
                                                                              2:shared.LicenseExistedException_Thrift lee,
                                                                              3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                              4:shared.PermissionNotGrantException_Thrift png,
                                                                              5:shared.ServiceHavingBeenShutdown_Thrift shbsd),

  shared.UpdateLicenseResponse_Thrift updateLicense_Thrift(1:shared.UpdateLicenseRequest_Thrift request) throws (
                                                                              1:shared.InvalidLicenseFileException_Thrift ilfe,
                                                                              2:shared.NoLicenseException_Thrift ntbue,
                                                                              3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                              4:shared.PermissionNotGrantException_Thrift png,
                                                                              5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                              6:shared.AccountNotFoundException_Thrift anfe,
                                                                              7:shared.LicenseException_Thrift le
                                                                              ),

  shared.ViewLicenseResponse_Thrift viewLicense_Thrift(1:shared.ViewLicenseRequest_Thrift request) throws (
                                                                              1:shared.ServiceIsNotAvailable_Thrift sina,
                                                                              2:shared.PermissionNotGrantException_Thrift png,
                                                                              3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                              4:shared.AccountNotFoundException_Thrift anfe,
                                                                              5:shared.LicenseException_Thrift le
                                                                              ),

  shared.UninstallLicenseResponse_Thrift uninstallLicense_Thrift(1:shared.UninstallLicenseRequest_Thrift request) throws (
                                                                              1:shared.NoLicenseException_Thrift nle,
                                                                              2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                              3:shared.PermissionNotGrantException_Thrift png,
                                                                              4:shared.ServiceHavingBeenShutdown_Thrift shbsd
                                                                              ),

  shared.OnlineDiskResponse onlineDisk(1:shared.OnlineDiskRequest request) throws (
                           1:shared.DiskNotFoundException_Thrift dnfe,
                           2:shared.DiskHasBeenOnline_Thrift dhble,
                           3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                           4:shared.AccessDeniedException_Thrift ade,
                           5:shared.InternalError_Thrift ie,
                           6:shared.ServiceIsNotAvailable_Thrift sina,
                           7:shared.PermissionNotGrantException_Thrift png,
                           8:shared.AccountNotFoundException_Thrift anfe,
                           9:shared.NetworkErrorException_Thrift nee
                           ),

  shared.OfflineDiskResponse offlineDisk(1:shared.OfflineDiskRequest request) throws (
                            1:shared.DiskNotFoundException_Thrift dnfe,
                           2:shared.DiskHasBeenOffline_Thrift dhbn,
                           3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                           4:shared.AccessDeniedException_Thrift ade,
                           5:shared.DiskIsBusy_Thrift dbe,
                           6:shared.NetworkErrorException_Thrift nee,
                           7:shared.ServiceIsNotAvailable_Thrift sina,
                           8:shared.PermissionNotGrantException_Thrift png,
                           9:shared.AccountNotFoundException_Thrift anfe
                           ),

    shared.SettleArchiveTypeResponse settleArchiveType(1:shared.SettleArchiveTypeRequest request) throws (
                            1:shared.DiskNotFoundException_Thrift dnfe,
                            2:shared.DiskSizeCanNotSupportArchiveTypes_thrift ds,
                            3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4:shared.ArchiveManagerNotSupportException_Thrift atn,
                            5:shared.DiskHasBeenOffline_Thrift dhbn,
                            6:shared.ServiceIsNotAvailable_Thrift sina,
                            7:shared.PermissionNotGrantException_Thrift png,
                            8:shared.NetworkErrorException_Thrift nee
                            ),

  shared.OnlineDiskResponse fixBrokenDisk(1:shared.OnlineDiskRequest request) throws (
                           1:shared.DiskNotFoundException_Thrift dnfe,
                           2:shared.DiskNotBroken_Thrift dnbe,
                           3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                           4:shared.AccessDeniedException_Thrift ade,
                           5:shared.AccountNotFoundException_Thrift anfe,
                           6: shared.ServiceIsNotAvailable_Thrift sina,
                           7:shared.PermissionNotGrantException_Thrift png,
                            8:shared.NetworkErrorException_Thrift nee
                           ),

  shared.OnlineDiskResponse fixConfigMismatchDisk(1:shared.OnlineDiskRequest request) throws (
                            1:shared.DiskNotFoundException_Thrift dnfe,
                           2:shared.DiskNotMismatchConfig_Thrift dnbe,
                           3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                           4:shared.AccessDeniedException_Thrift ade,
                           5:shared.AccountNotFoundException_Thrift anfe,
                           6:shared.ServiceIsNotAvailable_Thrift sina,
                           7:shared.PermissionNotGrantException_Thrift png,
                            8:shared.NetworkErrorException_Thrift nee
                           ),

  shared.CreateDomainResponse createDomain(1:shared.CreateDomainRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2:shared.InvalidInputException_Thrift iie,
                                                                                              3:shared.DomainExistedException_Thrift dee,
                                                                                              4:shared.DomainNameExistedException_Thrift dnee,
                                                                                              5:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              6:shared.DatanodeNotFreeToUseException_Thrift dnfe,
                                                                                              7:shared.DatanodeNotFoundException_Thrift dnnfe,
                                                                                              8:shared.DatanodeIsUsingException_Thrift dniue,
                                                                                              9:shared.PermissionNotGrantException_Thrift png,
                                                                                              10:shared.AccountNotFoundException_Thrift anfe,
                                                                                              11:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                              13:shared.NetworkErrorException_Thrift nee
                                                                                              ),

   shared.UpdateDomainResponse updateDomain(1:shared.UpdateDomainRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2:shared.InvalidInputException_Thrift iie,
                                                                                              3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              4:shared.DatanodeNotFreeToUseException_Thrift dnfe,
                                                                                              5:shared.DatanodeNotFoundException_Thrift dnnfe,
                                                                                              6:shared.DomainNotExistedException_Thrift dhbde,
                                                                                              7:shared.DatanodeIsUsingException_Thrift dniue,
                                                                                              8:shared.DomainIsDeletingException_Thrift dide,
                                                                                              9:shared.PermissionNotGrantException_Thrift png,
                                                                                              10:shared.AccountNotFoundException_Thrift anfe,
                                                                                              11:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                              13:shared.NetworkErrorException_Thrift nee,
                                                                                              14:shared.AccessDeniedException_Thrift ade,
                                                                                              15:shared.InstanceIsSubHealthException_Thrift ish
                                                                                              ),

   shared.RemoveDatanodeFromDomainResponse removeDatanodeFromDomain(1:shared.RemoveDatanodeFromDomainRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2:shared.InvalidInputException_Thrift iie,
                                                                                              3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              4:shared.FailToRemoveDatanodeFromDomainException_Thrift frdfde,
                                                                                              5:shared.DatanodeNotFoundException_Thrift dnnfe,
                                                                                              6:shared.DomainNotExistedException_Thrift dhbde,
                                                                                              7:shared.DomainIsDeletingException_Thrift dide,
                                                                                              8:shared.PermissionNotGrantException_Thrift png,
                                                                                              9:shared.AccessDeniedException_Thrift ade,
                                                                                              10:shared.AccountNotFoundException_Thrift anfe,
                                                                                              11:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                              13:shared.NetworkErrorException_Thrift nee
                                                                                              ),

   shared.DeleteDomainResponse deleteDomain(1:shared.DeleteDomainRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                            2:shared.InvalidInputException_Thrift iie,
                                                                            3:shared.DomainNotExistedException_Thrift dhbde,
                                                                            4:shared.ServiceIsNotAvailable_Thrift sina,
                                                                            5:shared.StillHaveStoragePoolException_Thrift shspe,
                                                                            6:shared.DomainIsDeletingException_Thrift dide,
                                                                            7:shared.ResourceNotExistsException_Thrift rne,
                                                                            8:shared.PermissionNotGrantException_Thrift png,
                                                                            9:shared.AccessDeniedException_Thrift ade,
                                                                            10:shared.AccountNotFoundException_Thrift anfe,
                                                                            11:shared.EndPointNotFoundException_Thrift epnfe,
                                                                            12:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                            13:shared.NetworkErrorException_Thrift nee
                                                                            ),

   shared.ListDomainResponse listDomains(1:shared.ListDomainRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2:shared.InvalidInputException_Thrift iie,
                                                                      3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                      4:shared.EndPointNotFoundException_Thrift epnfe,
                                                                      5:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                      6:shared.NetworkErrorException_Thrift nee
                                                                      ),


   shared.CreateStoragePoolResponse_Thrift createStoragePool(1:shared.CreateStoragePoolRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2:shared.InvalidInputException_Thrift iie,
                                                                                              3:shared.StoragePoolExistedException_Thrift see,
                                                                                              4:shared.StoragePoolNameExistedException_Thrift snee,
                                                                                              5:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              6:shared.ArchiveNotFreeToUseException_Thrift anftue,
                                                                                              7:shared.ArchiveNotFoundException_Thrift anfex,
                                                                                              8:shared.DomainNotExistedException_Thrift dnee,
                                                                                              9:shared.ArchiveIsUsingException_Thrift aiue,
                                                                                              10:shared.DomainIsDeletingException_Thrift dide,
                                                                                              11:shared.PermissionNotGrantException_Thrift png,
                                                                                              12:shared.AccessDeniedException_Thrift ade,
                                                                                              13:shared.AccountNotFoundException_Thrift anfe,
                                                                                              14:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                              15:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                              16:shared.NetworkErrorException_Thrift nee
                                                                                              ),

   shared.UpdateStoragePoolResponse_Thrift updateStoragePool(1:shared.UpdateStoragePoolRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2:shared.InvalidInputException_Thrift iie,
                                                                                              3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              4:shared.ArchiveNotFreeToUseException_Thrift anftue,
                                                                                              5:shared.ArchiveNotFoundException_Thrift anfex,
                                                                                              6:shared.StoragePoolNotExistedException_Thrift spnee,
                                                                                              7:shared.DomainNotExistedException_Thrift dnee,
                                                                                              8:shared.ArchiveIsUsingException_Thrift aiue,
                                                                                              9:shared.StoragePoolIsDeletingException_Thrift spide,
                                                                                              10:shared.PermissionNotGrantException_Thrift png,
                                                                                              11:shared.AccessDeniedException_Thrift ade,
                                                                                              12:shared.AccountNotFoundException_Thrift anfe,
                                                                                              13:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                              14:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                              15:shared.NetworkErrorException_Thrift nee
                                                                                              ),

   shared.RemoveArchiveFromStoragePoolResponse_Thrift removeArchiveFromStoragePool(1:shared.RemoveArchiveFromStoragePoolRequest_Thrift request) throws (
                                                                                                1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2:shared.InvalidInputException_Thrift iie,
                                                                                              3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              4:shared.FailToRemoveArchiveFromStoragePoolException_Thrift frafse,
                                                                                              5:shared.ArchiveNotFoundException_Thrift anfe,
                                                                                              6:shared.StoragePoolNotExistedException_Thrift spnee,
                                                                                              7:shared.DomainNotExistedException_Thrift dnee,
                                                                                              8:shared.StoragePoolIsDeletingException_Thrift spide,
                                                                                              9:shared.PermissionNotGrantException_Thrift png,
                                                                                              10:shared.AccessDeniedException_Thrift ade,
                                                                                              11:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                              12:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                              13:shared.NetworkErrorException_Thrift nee
                                                                                              ),

   shared.DeleteStoragePoolResponse_Thrift deleteStoragePool(1:shared.DeleteStoragePoolRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                            2:shared.InvalidInputException_Thrift iie,
                                                                            3:shared.StoragePoolNotExistedException_Thrift spnee,
                                                                            4:shared.ServiceIsNotAvailable_Thrift sina,
                                                                            5:shared.StillHaveVolumeException_Thrift shve,
                                                                            6:shared.DomainNotExistedException_Thrift dnee,
                                                                            7:shared.StoragePoolIsDeletingException_Thrift spide,
                                                                            8:shared.ResourceNotExistsException_Thrift rne,
                                                                            9:shared.PermissionNotGrantException_Thrift png,
                                                                              10:shared.AccessDeniedException_Thrift ade,
                                                                              11:shared.AccountNotFoundException_Thrift anfe,
                                                                              12:shared.EndPointNotFoundException_Thrift epnfe,
                                                                              13:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                              14:shared.NetworkErrorException_Thrift nee
                                                                            ),

   shared.ListStoragePoolResponse_Thrift listStoragePools(1:shared.ListStoragePoolRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2:shared.InvalidInputException_Thrift iie,
                                                                      3:shared.ServiceIsNotAvailable_Thrift sina,
                                                                      4:shared.AccountNotFoundException_Thrift anfe,
                                                                      5:shared.EndPointNotFoundException_Thrift epnfe,
                                                                      6:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                      7:shared.NetworkErrorException_Thrift nee,
                                                                      8:shared.ResourceNotExistsException_Thrift rnee
                                                                      ),



   shared.GetCapacityRecordResponse_Thrift getCapacityRecord(1: shared.GetCapacityRecordRequest_Thrift request) throws (
                                                                      1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2: shared.ServiceIsNotAvailable_Thrift sina),
   shared.ListStoragePoolCapacityResponse_Thrift listStoragePoolCapacity(1:shared.ListStoragePoolCapacityRequest_Thrift request) throws (
                                                                      1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                      2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                      3: shared.InvalidInputException_Thrift iie),


  shared.ListIscsiAppliedAccessRulesResponse_Thrift listIscsiAppliedAccessRules(1:shared.ListIscsiAppliedAccessRulesRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                3: shared.DriverContainerIsINCException_Thrift diit,
                                                                                                4: shared.NetworkErrorException_Thrift nee
                                                                                                ),

   icshared.ListVolumesResponse listVolumes(1:icshared.ListVolumesRequest request) throws (
      						1:shared.AccessDeniedException_Thrift ade,
         					2:shared.ResourceNotExistsException_Thrift rnee,
         					3:shared.InvalidInputException_Thrift iie,
         					4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
         					5:shared.VolumeNotFoundException_Thrift vnfe,
         					6:shared.ServiceIsNotAvailable_Thrift sina,
         					7:shared.AccountNotFoundException_Thrift anf,
                              8:shared.EndPointNotFoundException_Thrift epnfe,
                              9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                              10:shared.NetworkErrorException_Thrift nee
         					),

   icshared.GetVolumeResponse getVolume(1:icshared.GetVolumeRequest request) throws (
                           1:shared.AccessDeniedException_Thrift ade,
                          2:shared.AccountNotFoundException_Thrift anfe,
                          3:shared.InvalidInputException_Thrift iie,
                          4:shared.NotEnoughSpaceException_Thrift nese,
                          5:shared.VolumeNotFoundException_Thrift vnfe,
                          6:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                          7:shared.ServiceIsNotAvailable_Thrift sina,
                          8:shared.PermissionNotGrantException_Thrift png
                          ),

   shared.GetCapacityResponse getCapacity(1:shared.GetCapacityRequest request) throws (1:shared.StorageEmptyException_Thrift see,
                                                                                           2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                          3:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                          4:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                          5:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                          6:shared.NetworkErrorException_Thrift nee
                                                                                           ),

    ReportJustCreatedSegmentUnitResponse reportJustCreatedSegmentUnit(1: ReportJustCreatedSegmentUnitRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                                2: shared.ServiceIsNotAvailable_Thrift sina),

    shared.CreateDefaultDomainAndStoragePoolResponse_Thrift createDefaultDomainAndStoragePool(1: shared.CreateDefaultDomainAndStoragePoolRequest_Thrift request) throws
                                                                                                           (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                           2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                            3: shared.DatanodeNotFoundException_Thrift dnfe,
                                                                                                            4: shared.NetworkErrorException_Thrift nee,
                                                                                                            5: shared.DomainNameExistedException_Thrift dnee,
                                                                                                            6: shared.DatanodeIsUsingException_Thrift diue,
                                                                                                            7: shared.DatanodeNotFreeToUseException_Thrift dnftue,
                                                                                                            8: shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                            9: shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                            10: shared.PermissionNotGrantException_Thrift pnge,
                                                                                                            11: shared.InvalidInputException_Thrift iie,
                                                                                                            12: shared.AccountNotFoundException_Thrift anfe,
                                                                                                            13: shared.DomainExistedException_Thrift dee,
                                                                                                            14: shared.DomainNotExistedException_Thrift dnotee,
                                                                                                            15: shared.StoragePoolNameExistedException_Thrift spnee,
                                                                                                            16: shared.ArchiveIsUsingException_Thrift aiue,
                                                                                                            17: shared.ArchiveNotFoundException_Thrift arnfe,
                                                                                                            18: shared.ArchiveNotFreeToUseException_Thrift arnftue,
                                                                                                            19: shared.StoragePoolExistedException_Thrift spee,
                                                                                                            20: shared.AccessDeniedException_Thrift ade,
                                                                                                            21: shared.DomainIsDeletingException_Thrift dide
                                                                                                           ),
    shared.ListOperationsResponse listOperations(1:shared.ListOperationsRequest request) throws (1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                 3: shared.OperationNotFoundException_Thrift onf,
                                                                                                 4:shared.PermissionNotGrantException_Thrift png
                                                                                                 ),

   icshared.RecycleVolumeResponse recycleVolume(1:icshared.RecycleVolumeRequest request) throws (
                        1:shared.AccessDeniedException_Thrift ade,
                        2:shared.NotEnoughSpaceException_Thrift nese,
                        3:shared.VolumeNotFoundException_Thrift vnfe,
                        4:shared.VolumeCannotBeRecycledException_Thrift vcbre,
                        5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                        6:shared.VolumeInExtendingException_Thrift vee,
                        7:shared.ExistsDriverException_Thrift ede,
                        8:shared.ServiceIsNotAvailable_Thrift sina,
                        9:shared.PermissionNotGrantException_Thrift png,
                        10:shared.AccountNotFoundException_Thrift anfe,
                        11:shared.VolumeWasRollbackingException_Thrift vwre,
                         12:shared.EndPointNotFoundException_Thrift enfe,
                         13:shared.TooManyEndPointFoundException_Thrift tmepfe,
                         14:shared.NetworkErrorException_Thrift nee
                        ),


    icshared.MoveVolumeResponse moveVolume(1:icshared.MoveVolumeRequest request) throws (1:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                     2:shared.InvalidInputException_Thrift iie,
                                                                                     3:shared.AccessDeniedException_Thrift ade,
                                                                                     4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                     5:shared.VolumeExistingException_Thrift vee,
                                                                                     6:shared.VolumeNameExistedException_Thrift vnee,
                                                                                     7:shared.BadLicenseTokenException_Thrift blte,
                                                                                     8:shared.UselessLicenseException_Thrift ule,
                                                                                     9:shared.NotEnoughLicenseTokenException_Thrift nelte,
                                                                                     10:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                     11:shared.StoragePoolNotExistInDoaminException_Thrift sneide,
                                                                                     12:shared.DomainNotExistedException_Thrift dnee,
                                                                                     13:shared.StoragePoolNotExistedException_Thrift spnee,
                                                                                     14:shared.DomainIsDeletingException_Thrift dide,
                                                                                     15:shared.StoragePoolIsDeletingException_Thrift spide,
                                                                                     16:shared.NotEnoughGroupException_Thrift nege,
                                                                                     17:shared.PermissionNotGrantException_Thrift png,
                                                                                     18:shared.SrcVolumeHaveDriverException_Thrift svhde,
                                                                                     19:shared.NotEnoughSpaceException_Thrift nes,
                                                                                     20:shared.AccountNotFoundException_Thrift anfe,
                                                                                     21:shared.VolumeNotAvailableException_Thrift vnae,
                                                                                     22:shared.VolumeWasRollbackingException_Thrift vwre,
                                                                                     23:shared.SnapshotNotFoundException_Thrift snfe,
                                                                                     24:shared.EndPointNotFoundException_Thrift enfe,
                                                                                     25:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                     26:shared.NetworkErrorException_Thrift nee,
                                                                                     27:shared.LicenseException_Thrift le,
                                                                                     28:shared.NotEnoughNormalGroupException_Thrift nenge,
                                                                                     29:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe
                                                                                     ),

    icshared.MoveVolumeOnlineResponse moveVolumeOnline(1:icshared.MoveVolumeOnlineRequest request) throws (1:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                                            2:shared.InvalidInputException_Thrift iie,
                                                                                                            3:shared.AccessDeniedException_Thrift ade,
                                                                                                            4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                            5:shared.VolumeExistingException_Thrift vee,
                                                                                                            6:shared.VolumeNameExistedException_Thrift vnee,
                                                                                                            7:shared.BadLicenseTokenException_Thrift blte,
                                                                                                            8:shared.UselessLicenseException_Thrift ule,
                                                                                                            9:shared.NotEnoughLicenseTokenException_Thrift nelte,
                                                                                                            10:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                            11:shared.StoragePoolNotExistInDoaminException_Thrift sneide,
                                                                                                            12:shared.DomainNotExistedException_Thrift dnee,
                                                                                                            13:shared.StoragePoolNotExistedException_Thrift spnee,
                                                                                                            14:shared.DomainIsDeletingException_Thrift dide,
                                                                                                            15:shared.StoragePoolIsDeletingException_Thrift spide,
                                                                                                            16:shared.NotEnoughGroupException_Thrift nege,
                                                                                                            17:shared.PermissionNotGrantException_Thrift png,
                                                                                                            18:shared.SrcVolumeHaveDriverException_Thrift svhde,
                                                                                                            19:shared.NotEnoughSpaceException_Thrift nes,
                                                                                                            20:shared.AccountNotFoundException_Thrift anfe,
                                                                                                            21:shared.VolumeNotAvailableException_Thrift vnae,
                                                                                                            22:shared.VolumeWasRollbackingException_Thrift vwre,
                                                                                                            23:shared.SnapshotNotFoundException_Thrift snfe,
                                                                                                            24:shared.EndPointNotFoundException_Thrift enfe,
                                                                                                            25:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                            26:shared.NetworkErrorException_Thrift nee,
                                                                                                            27:shared.LicenseException_Thrift le,
                                                                                                            28:shared.NotEnoughNormalGroupException_Thrift nenge,
                                                                                                            29:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe
                                                                                                            ),

    shared.FixVolumeResponse_Thrift fixVolume(1:shared.FixVolumeRequest_Thrift request) throws (1:shared.AccountNotFoundException_Thrift anfe,
                                                                                                2:shared.VolumeNotFoundException_Thrift vnf,
                                                                                                3:shared.AccessDeniedException_Thrift ad,
                                                                                                4:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                5:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                6:shared.PermissionNotGrantException_Thrift png,
                                                                                                7:shared.EndPointNotFoundException_Thrift enfe,
                                                                                                8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                9:shared.NetworkErrorException_Thrift nee,
                                                                                                10:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe
                                                                                                ),

    shared.ConfirmFixVolumeResponse_Thrift confirmFixVolume(1:shared.ConfirmFixVolumeRequest_Thrift request) throws (1:shared.InternalError_Thrift ie,
                                                                                                                     2:shared.VolumeNotFoundException_Thrift vnf,
                                                                                                                     3:shared.AccessDeniedException_Thrift ad,
                                                                                                                     4:shared.LackDatanodeException_Thrift ld,
                                                                                                                     5:shared.NotEnoughSpaceException_Thrift nes,
                                                                                                                     6:shared.InvalidInputException_Thrift ii,
                                                                                                                     7:shared.ServiceIsNotAvailable_Thrift sin,
                                                                                                                     8:shared.VolumeFixingOperationException_Thrift vfo,
                                                                                                                     9:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                     10:shared.FrequentFixVolumeRequest_Thrift ffv,
                                                                                                                     11:shared.PermissionNotGrantException_Thrift png,
                                                                                                                    12:shared.AccountNotFoundException_Thrift anfe,
                                                                                                                    13:shared.EndPointNotFoundException_Thrift enfe,
                                                                                                                    14:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                    15:shared.NetworkErrorException_Thrift nee
                                                                                                                     ),

    MarkVolumesReadWriteResponse markVolumesReadWrite(1:MarkVolumesReadWriteRequest request) throws (1:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                     2:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                     3:shared.PermissionNotGrantException_Thrift png,
                                                                                                    4:shared.AccountNotFoundException_Thrift anfe,
                                                                                                    5:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                                    6:shared.EndPointNotFoundException_Thrift enfe,
                                                                                                    7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                    8:shared.NetworkErrorException_Thrift nee
                                                                                                     ),

    CheckVolumeIsReadOnlyResponse checkVolumeIsReadOnly(1:CheckVolumeIsReadOnlyRequest request) throws (1:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                        2:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                        3:shared.VolumeIsMarkWriteException_Thrift vimw,
                                                                                                        4:shared.VolumeIsAppliedWriteAccessRuleException_Thrift viawar,
                                                                                                        5:shared.VolumeIsConnectedByWritePermissionClientException_Thrift vicbwpc,
                                                                                                        6:shared.PermissionNotGrantException_Thrift png,
                                                                                                        7:shared.VolumeNotFoundException_Thrift vnfe,
                                                                                                        8:shared.EndPointNotFoundException_Thrift enfe,
                                                                                                        9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                        10:shared.NetworkErrorException_Thrift nee
                                                                                                        ),

    shared.GetDriverConnectPermissionResponse_Thrift  getDriverConnectPermission(1:shared.GetDriverConnectPermissionRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                                                    2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                                                    3:shared.NetworkErrorException_Thrift nee
                                                                                                                                                   ),
CreateSnapshotVolumeResponse createSnapshotVolume(1:CreateSnapshotVolumeRequest request) throws (
                                                            1:shared.NotEnoughSpaceException_Thrift nese,
                                                            2:shared.SnapshotCountReachMaxException_Thrift seet,
                                                            3:shared.SnapshotNameExistException_Thrift sbet,
                                                            4:shared.ServiceIsNotAvailable_Thrift sina,
                                                            5:shared.AccountNotFoundException_Thrift anfe,
                                                            6:shared.VolumeUnderOperationException_Thrift vuoe,
                                                            7:shared.InvalidInputException_Thrift iie,
                                                            8:shared.VolumeNotAvailableException_Thrift vnae,
                                                            9:shared.NoDriverLaunchException_Thrift ndle,
                                                            10:shared.VolumeWasRollbackingException_Thrift vwre,
                                                            11:shared.SnapshotDeletingException_Thrift sde,
                                                            12:shared.SnapshotCreatingException_Thrift sce,
                                                            13:shared.SnapshotRollingBackException_Thrift srbe,
                                                            14:shared.DriverLaunchingException_Thrift dle,
                                                            15:shared.DriverUnmountingException_Thrift due,
                                                            16:shared.VolumeDeletingException_Thrift vde,
                                                            17:shared.SnapshotExistException_Thrift see,
                                                            18:shared.AccessDeniedException_Thrift ade,
                                                            19:shared.VolumeNotFoundException_Thrift vnfe,
                                                            20:shared.SnapshotNotFoundException_Thrift snfe,
                                                            21:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                            22:shared.VolumeNameExistedException_Thrift vnee,
                                                            23:shared.BadLicenseTokenException_Thrift blte,
                                                            24:shared.UselessLicenseException_Thrift ule,
                                                            25:shared.NotEnoughLicenseTokenException_Thrift nelte,
                                                            26:shared.StoragePoolNotExistInDoaminException_Thrift spne,
                                                            27:shared.DomainNotExistedException_Thrift dnee,
                                                            28:shared.StoragePoolNotExistedException_Thrift spnee,
                                                            29:shared.DomainIsDeletingException_Thrift dide,
                                                            30:shared.StoragePoolIsDeletingException_Thrift spide,
                                                            31:shared.NotEnoughGroupException_Thrift nege,
                                                            32:shared.PermissionNotGrantException_Thrift png,
                                                            33:shared.SnapshotDescriptionTooLongException_Thrift sdte,
                                                            34:shared.SnapshotNameTooLongException_Thrift snte,
                                                            35:shared.SnapshotVersionMismatchException_Thrift svme,
                                                            36:shared.EndPointNotFoundException_Thrift epnfe,
                                                            37:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                            38:shared.NetworkErrorException_Thrift nee,
                                                            39:shared.LicenseException_Thrift le,
                                                            40:shared.RootVolumeBeingDeletedException_Thrift rvbde,
                                                            41:shared.RootVolumeNotFoundException_Thrift rvnfe,
                                                            42:shared.VolumeExistingException_Thrift vee,
                                                            43:shared.NotEnoughNormalGroupException_Thrift nenge,
                                                            44:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe,
                                                            45:monitorserver.CounterKeyIllegalException_Thrift ckie
                                                            ),

    CreateRoleResponse createRole(1:CreateRoleRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                     2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                     3:CreateRoleNameExistedException_Thrift crne,
                                                                     4:shared.PermissionNotGrantException_Thrift png,
                                                                     5:shared.AccountNotFoundException_Thrift anfe
                                                                     ),

    AssignRolesResponse assignRoles(1:AssignRolesRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                        2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                        3:shared.CRUDSuperAdminAccountException_Thrift crudsaa,
                                                                        4:shared.PermissionNotGrantException_Thrift png,
                                                                        5:shared.AccountNotFoundException_Thrift anfe
                                                                        ),

    UpdateRoleResponse updateRole(1:UpdateRoleRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                     2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                     3:shared.RoleNotExistedException_Thrift rne,
                                                                     4:shared.CRUDBuiltInRoleException_Thrift crudbir,
                                                                     5:shared.PermissionNotGrantException_Thrift png,
                                                                     6:shared.AccountNotFoundException_Thrift anfe
                                                                     ),

    DeleteRolesResponse deleteRoles(1:DeleteRolesRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                  2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                  3:shared.DeleteRoleException_Thrift dr,
                                                                  4:shared.PermissionNotGrantException_Thrift png,
                                                                  5:shared.AccountNotFoundException_Thrift anfe
                                                                  ),

    ListAPIsResponse listAPIs(1:ListAPIsRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                               2:shared.ServiceIsNotAvailable_Thrift sina),

    ListRolesResponse listRoles(1:ListRolesRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                  2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                  3:shared.PermissionNotGrantException_Thrift png,
                                                                  4:shared.AccountNotFoundException_Thrift anfe
                                                                  ),

   shared.CreateAccountResponse createAccount(1:shared.CreateAccountRequest request) throws (
   						1:shared.AccessDeniedException_Thrift ade,
      					2:shared.AccountNotFoundException_Thrift anfe,
      					3:shared.InvalidInputException_Thrift iie,
      					4:shared.AccountAlreadyExistsException_Thrift uaee,
      					5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
      					6:shared.ServiceIsNotAvailable_Thrift sina,
      					7:shared.PermissionNotGrantException_Thrift png
      					),

   shared.DeleteAccountsResponse deleteAccounts(1:shared.DeleteAccountsRequest request) throws (
   						1:shared.AccessDeniedException_Thrift ade,
      					2:shared.InvalidInputException_Thrift iie,
      					3:shared.AccountNotFoundException_Thrift unfe,
      					4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
      					5:shared.ServiceIsNotAvailable_Thrift sina,
      					6:shared.DeleteLoginAccountException_Thrift dla,
      					7:shared.PermissionNotGrantException_Thrift png
      					),

   shared.UpdatePasswordResponse updatePassword(1:shared.UpdatePasswordRequest request) throws (
   						1:shared.OlderPasswordIncorrectException_Thrift opie,
      					2:shared.InsufficientPrivilegeException_Thrift ipe,
      					3:shared.InvalidInputException_Thrift iie,
      					4:shared.AccountNotFoundException_Thrift unfe,
      					5:shared.ServiceHavingBeenShutdown_Thrift shbsd,
      					6:shared.ServiceIsNotAvailable_Thrift sina),

   shared.ListAccountsResponse listAccounts(1:shared.ListAccountsRequest request) throws (
   						1:shared.AccessDeniedException_Thrift ade,
      					2:shared.AccountNotFoundException_Thrift anfe,
      					3:shared.InvalidInputException_Thrift iie,
      					4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
      					5:shared.ServiceIsNotAvailable_Thrift sina
      					),

   shared.AuthenticateAccountResponse authenticateAccount(1:shared.AuthenticateAccountRequest request) throws (
   						1:shared.AuthenticationFailedException_Thrift afe,
      					2:shared.InvalidInputException_Thrift iie,
      					3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
      					4:shared.ServiceIsNotAvailable_Thrift sina),

   shared.ResetAccountPasswordResponse resetAccountPassword(1:shared.ResetAccountPasswordRequest request) throws (
   						1:shared.InvalidInputException_Thrift iie,
	                    2:shared.AccessDeniedException_Thrift ade,
	                    3:shared.AccountNotFoundException_Thrift unfe,
	                    4:shared.ServiceHavingBeenShutdown_Thrift shbsd,
	                    5:shared.ServiceIsNotAvailable_Thrift sina,
	                    6:shared.PermissionNotGrantException_Thrift png),

   shared.ListResourcesResponse listResources(1:shared.ListResourcesRequest request) throws (
	                    1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
	                    2:shared.ServiceIsNotAvailable_Thrift sina,
	                    3:shared.PermissionNotGrantException_Thrift png,
	                    4:shared.AccountNotFoundException_Thrift anfe
	                    ),

   shared.AssignResourcesResponse assignResources(1:shared.AssignResourcesRequest request) throws (
	                    1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
	                    2:shared.ServiceIsNotAvailable_Thrift sina,
	                    3:shared.PermissionNotGrantException_Thrift png,
	                    4:shared.AccountNotFoundException_Thrift anfe
	                    ),

    shared.DeleteServerNodesResponse_Thrift deleteServerNodes(1:shared.DeleteServerNodesRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                    2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                    3:shared.ServerNodeIsUnknown_Thrift sniu,
                                                                                                                    4:shared.PermissionNotGrantException_Thrift png,
                                                                                                                    5:shared.AccountNotFoundException_Thrift anf),

    shared.UpdateServerNodeResponse_Thrift updateServerNode(1:shared.UpdateServerNodeRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                    2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                    3:shared.PermissionNotGrantException_Thrift png,
                                                                                                                    4:shared.AccountNotFoundException_Thrift anf,
                                                                                                                    5:shared.ServerNodePositionIsRepeatException_Thrift snpire),

    shared.ListServerNodesResponse_Thrift listServerNodes(1:shared.ListServerNodesRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                 2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                 3:shared.PermissionNotGrantException_Thrift png,
                                                                                                                 4:shared.AccountNotFoundException_Thrift anf,
                                                                                                                 5:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                 6:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                 7:shared.NetworkErrorException_Thrift nee
                                                                                                                 ),

    shared.ListServerNodeByIdResponse_Thrift listServerNodeById(1:shared.ListServerNodeByIdRequest_Thrift request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                                                                     2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                                                                    3:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                                                    4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                                                    5:shared.NetworkErrorException_Thrift nee
                                                                                                                     ),

    LogoutResponse logout(1:LogoutRequest request) throws(1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                          2:shared.ServiceIsNotAvailable_Thrift sina,
                                                          3:shared.AccountNotFoundException_Thrift anf),

    InstanceMaintainResponse markInstanceMaintenance(1:InstanceMaintainRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                            2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                            3:shared.PermissionNotGrantException_Thrift png,
                                                                            4:shared.AccountNotFoundException_Thrift anf,
                                                                            5:shared.EndPointNotFoundException_Thrift epnfe,
                                                                            6:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                            7:shared.NetworkErrorException_Thrift nee
                                                                            ),

    CancelMaintenanceResponse cancelInstanceMaintenance(1:CancelMaintenanceRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                            2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                            3:shared.PermissionNotGrantException_Thrift png,
                                                                            4:shared.AccountNotFoundException_Thrift anf,
                                                                            5:shared.EndPointNotFoundException_Thrift epnfe,
                                                                            6:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                            7:shared.NetworkErrorException_Thrift nee
                                                                            ),

    ListInstanceMaintenancesResponse listInstanceMaintenances(1:ListInstanceMaintenancesRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                            2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                            3:shared.PermissionNotGrantException_Thrift png,
                                                                            4:shared.AccountNotFoundException_Thrift anf),

    SaveOperationLogsToCSVResponse saveOperationLogsToCSV(1:SaveOperationLogsToCSVRequest request) throws (
                                                                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                                                            2:shared.ServiceIsNotAvailable_Thrift sina,
                                                                            3:shared.PermissionNotGrantException_Thrift png,
                                                                            4:shared.AccountNotFoundException_Thrift anf,
                                                                            5:shared.UnsupportedEncodingException_Thrift usee
                                                                            ),
    //********** Driver Qos begin*****************/

    shared.ApplyIOLimitationsResponse applyIOLimitations(1:shared.ApplyIOLimitationsRequest request) throws (
                            1:shared.VolumeNotFoundException_Thrift vnfe,
                            2:shared.VolumeBeingDeletedException_Thrift vbde,
                            3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4:FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                            5:shared.ServiceIsNotAvailable_Thrift sina,
                            6:shared.ApplyFailedDueToVolumeIsReadOnlyException_Thrift afdtviro,
                            7:shared.AccountNotFoundException_Thrift anf,
                            8:shared.PermissionNotGrantException_Thrift png,
                            9:shared.EndPointNotFoundException_Thrift epnfe,
                            10:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            11:shared.NetworkErrorException_Thrift nee
                            ),

    shared.CancelIOLimitationsResponse cancelIOLimitations(1:shared.CancelIOLimitationsRequest request) throws (
                            1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2:FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                            3:shared.ServiceIsNotAvailable_Thrift sina,
                            4:shared.AccessRuleNotApplied_Thrift arna,
                            5:shared.AccountNotFoundException_Thrift anf,
                            6:shared.PermissionNotGrantException_Thrift png,
                            7:shared.EndPointNotFoundException_Thrift epnfe,
                            8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            9:shared.NetworkErrorException_Thrift nee
                            ),
   shared.DeleteIOLimitationsResponse deleteIOLimitations(1:shared.DeleteIOLimitationsRequest request) throws (
                             1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                             2:FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                             3:shared.ServiceIsNotAvailable_Thrift sina,
                             4:shared.AccountNotFoundException_Thrift anf,
                             5:shared.PermissionNotGrantException_Thrift png,
                             6:shared.EndPointNotFoundException_Thrift epnfe,
                             7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                             8:shared.NetworkErrorException_Thrift nee
                             ),


    shared.ListIOLimitationsResponse listIOLimitations(1:shared.ListIOLimitationsRequest request) throws (
                            1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2: shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.EndPointNotFoundException_Thrift epnfe,
                            4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            5:shared.NetworkErrorException_Thrift nee
                            ),

    shared.GetIOLimitationsResponse getIOLimitations(1:shared.GetIOLimitationsRequest request) throws (
                            1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2: shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.EndPointNotFoundException_Thrift epnfe,
                            4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            5:shared.NetworkErrorException_Thrift nee
                            ),

    shared.CreateIOLimitationsResponse createIOLimitations(1:shared.CreateIOLimitationsRequest request) throws (
                            1:shared.IOLimitationsDuplicate_Thrift vard,
                            2:shared.InvalidInputException_Thrift iie,
                            3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4:shared.ServiceIsNotAvailable_Thrift sina,
                            5:shared.AccountNotFoundException_Thrift anf,
                            6:shared.PermissionNotGrantException_Thrift png,
                            7:shared.IOLimitationTimeInterLeaving_Thrift ioltil,
                            8:shared.EndPointNotFoundException_Thrift epnfe,
                            9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            10:shared.NetworkErrorException_Thrift nee
                            ),

    shared.UpdateIOLimitationsResponse updateIOLimitations(1:shared.UpdateIOLimitationRulesRequest request) throws (
                            1:shared.IOLimitationsDuplicate_Thrift vard,
                            2:shared.InvalidInputException_Thrift iie,
                            3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4:shared.ServiceIsNotAvailable_Thrift sina,
                            5:shared.AccountNotFoundException_Thrift anf,
                            6:shared.PermissionNotGrantException_Thrift png,
                            7:shared.IOLimitationTimeInterLeaving_Thrift ioltil,
                            8:shared.EndPointNotFoundException_Thrift epnfe,
                            9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            10:shared.NetworkErrorException_Thrift nee
                            ),

    shared.GetIOLimitationAppliedDriversResponse getIOLimitationAppliedDrivers(1: shared.GetIOLimitationAppliedDriversRequest request) throws (
                            1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2:shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.PermissionNotGrantException_Thrift png,
                            4:shared.EndPointNotFoundException_Thrift epnfe,
                            5:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            6:shared.NetworkErrorException_Thrift nee
                            ),

    //********** Driver Qos end*****************/


    //********** StoragePool Qos begin************/

    shared.ApplyMigrationRulesResponse applyMigrationRules(1:shared.ApplyMigrationRulesRequest request) throws (
                            1: shared.VolumeNotFoundException_Thrift vnfe,
                            2: shared.VolumeBeingDeletedException_Thrift vbde,
                            3: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4: FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                            5:shared.ServiceIsNotAvailable_Thrift sina,
                            6: shared.ApplyFailedDueToVolumeIsReadOnlyException_Thrift afdtviro,
                            7:shared.AccountNotFoundException_Thrift anf,
                            8:shared.PermissionNotGrantException_Thrift png,
                            9:shared.EndPointNotFoundException_Thrift epnfe,
                            10:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            11:shared.NetworkErrorException_Thrift nee
                            ),

    shared.CancelMigrationRulesResponse cancelMigrationRules(1:shared.CancelMigrationRulesRequest request) throws (
                            1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2:FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                            3:shared.ServiceIsNotAvailable_Thrift sina,
                            4:shared.AccessRuleNotApplied_Thrift arna,
                            5:shared.AccountNotFoundException_Thrift anf,
                            6:shared.PermissionNotGrantException_Thrift png,
                            7:shared.EndPointNotFoundException_Thrift epnfe,
                            8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            9:shared.NetworkErrorException_Thrift nee
                            ),

    shared.DeleteMigrationRulesResponse deleteMigrationRules(1:shared.DeleteMigrationRulesRequest request) throws (
                            1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2:FailedToTellDriverAboutAccessRulesException_Thrift fttdaare,
                            3:shared.ServiceIsNotAvailable_Thrift sina,
                            4:shared.AccountNotFoundException_Thrift anf,
                            5:shared.PermissionNotGrantException_Thrift png,
                            6:shared.EndPointNotFoundException_Thrift epnfe,
                            7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            8:shared.NetworkErrorException_Thrift nee,
                            9:shared.BuiltInMigrationRuleNotAllowedDeletedException_Thrift bimrnade
                            ),

    shared.ListMigrationRulesResponse listMigrationRules(1:shared.ListMigrationRulesRequest request) throws (
                            1: shared.ServiceIsNotAvailable_Thrift sina,
                            2:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            3:shared.EndPointNotFoundException_Thrift epnfe,
                            4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            5:shared.NetworkErrorException_Thrift nee
                            ),

    shared.GetMigrationRulesResponse getMigrationRules(1:shared.GetMigrationRulesRequest request) throws (
                            1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2: shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.EndPointNotFoundException_Thrift epnfe,
                            4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            5:shared.NetworkErrorException_Thrift nee
                            ),

    shared.CreateMigrationRulesResponse createMigrationRules(1:shared.CreateMigrationRulesRequest request) throws (
                            1:shared.MigrationRuleDuplicate_Thrift vard,
                            2:shared.InvalidInputException_Thrift iie,
                            3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4:shared.ServiceIsNotAvailable_Thrift sina,
                            5:shared.AccountNotFoundException_Thrift anf,
                            6:shared.PermissionNotGrantException_Thrift png,
                            7:shared.EndPointNotFoundException_Thrift epnfe,
                            8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            9:shared.NetworkErrorException_Thrift nee
                            ),

    shared.UpdateMigrationRulesResponse updateMigrationRules(1:shared.UpdateMigrationRulesRequest request) throws (
                            1:shared.MigrationRuleDuplicate_Thrift vard,
                            2:shared.InvalidInputException_Thrift iie,
                            3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4:shared.ServiceIsNotAvailable_Thrift sina,
                            5:shared.AccountNotFoundException_Thrift anf,
                            6:shared.PermissionNotGrantException_Thrift png,
                            7:shared.EndPointNotFoundException_Thrift epnfe,
                            8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            9:shared.NetworkErrorException_Thrift nee,
                            10:shared.MigrationRuleNotExists mrne,
                            11:shared.BuiltInMigrationRuleNotAllowedUpdatedException_Thrift bimrnaue
                            ),


    shared.GetAppliedStoragePoolsResponse getAppliedStoragePools(1: shared.GetAppliedStoragePoolsRequest request) throws (
                            1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2:shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.MigrationRuleNotExists mrne,
                            4:shared.EndPointNotFoundException_Thrift epnfe,
                            5:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            6:shared.NetworkErrorException_Thrift nee
                            ),

    //********** StoragePool Qos end************/

    //********** iscsi chap control begin ********** /
    shared.SetIscsiChapControlResponse_Thrift  setIscsiChapControl(1:shared.SetIscsiChapControlRequest_Thrift request) throws (
                            1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            2:shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.EndPointNotFoundException_Thrift epnfe,
                            4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            5:shared.NetworkErrorException_Thrift nee
                            ),
    //********** iscsi chap control end   ********** /

    icshared.GetLimitsResponse getLimits(1:icshared.GetLimitsRequest request) throws (
                            1:shared.DriverNotFoundException_Thrift dnfe,
                            2:shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            4:shared.EndPointNotFoundException_Thrift epnfe,
                            5:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            6:shared.NetworkErrorException_Thrift nee
                            ),

    icshared.AddOrModifyIOLimitResponse addOrModifyIOLimit(1:icshared.AddOrModifyIOLimitRequest request) throws (
                            1:shared.DriverNotFoundException_Thrift dnfe
                            2:shared.InvalidInputException_Thrift iie,
                            3:shared.AlreadyExistStaticLimitationException_Thrift aesle,
                            4:shared.ServiceIsNotAvailable_Thrift sina,
                            5:shared.PermissionNotGrantException_Thrift png,
                            6:shared.AccessDeniedException_Thrift ad,
                            7:shared.AccountNotFoundException_Thrift anf,
                            8:shared.DynamicIOLimitationTimeInterleavingException_Thrift diltie,
                            9:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            10:shared.EndPointNotFoundException_Thrift epnfe,
                            11:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            12:shared.NetworkErrorException_Thrift nee
                            ),

    icshared.DeleteIOLimitResponse deleteIOLimit(1:icshared.DeleteIOLimitRequest request) throws (
                            1:shared.DriverNotFoundException_Thrift dnfe
                            2:shared.InvalidInputException_Thrift iie,
                            3:shared.ServiceIsNotAvailable_Thrift sina,
                            4:shared.PermissionNotGrantException_Thrift png,
                            5:shared.AccessDeniedException_Thrift ad,
                            6:shared.AccountNotFoundException_Thrift anf,
                            7:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                            8:shared.EndPointNotFoundException_Thrift epnfe,
                            9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            10:shared.NetworkErrorException_Thrift nee
                            ),

    icshared.ChangeLimitTypeResponse changeLimitType(1:icshared.ChangeLimitTypeRequest request) throws (
                            1:shared.DriverNotFoundException_Thrift dnfe
                            2:shared.InvalidInputException_Thrift iie,
                            3:shared.ServiceIsNotAvailable_Thrift sina,
                            4:shared.PermissionNotGrantException_Thrift png,
                            5:shared.AccessDeniedException_Thrift ad,
                            6:shared.AccountNotFoundException_Thrift anf,
                            7:shared.ServiceHavingBeenShutdown_Thrift shbsd
                            ),
    shared.CopyVolumeToExistVolumeResponse_Thrift copyVolumeToExistVolume(1:shared.CopyVolumeToExistVolumeRequest_Thrift request) throws(
                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                            2:shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.OriVolumeCanNotFoundException_Thrift ovcnfe,
                            4:shared.DestVolumeCanNotFoundException_Thrift dvcnfe,
                            5:shared.DestVolumeSmallerThanOriVolumeException_Thrift dvstove,
                            6:shared.OriVolumeNotAvailableException_Thrift ovnae,
                            7:shared.DestVolumeNotAvailableException_Thrift dvnae,
                            8:shared.AccountNotFoundException_Thrift anf,
                            9:shared.PermissionNotGrantException_Thrift png,
                            10:shared.AccessDeniedException_Thrift ad,
                            11:shared.DestVolumeIsCopyingException_Thrift dvice,
                            12:shared.OriVolumeHasDriverWhenCopyException_Thrift ovhdwce,
                            13:shared.DestVolumeHasDriverWhenCopyException_Thrift dvhdwce,
                            14:shared.VolumeNotFoundException_Thrift vnfe,
                            15:shared.InvalidInputException_Thrift iie,
                            16:shared.VolumeNameExistedException_Thrift vnee,
                            17:shared.EndPointNotFoundException_Thrift epnfe,
                            18:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            19:shared.NetworkErrorException_Thrift nee,
                            20:shared.VolumeInMoveOnlineDoNotHaveOperationException_Thrift vimodnhoe
                            ),
    shared.ChangeDiskLightStatusResponse changeDiskLightStatus(1:shared.ChangeDiskLightStatusRequest request) throws(
                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                            2:shared.ServiceIsNotAvailable_Thrift sina,
                            3:shared.ChangeDiskLightStatusTimeoutException_Thrift cdlse,
                            4:shared.PermissionNotGrantException_Thrift png,
                            5:shared.AccountNotFoundException_Thrift anf,
                            6:monitorserver.IllegalParameterException_Thrift ipe,
                            7:shared.EndPointNotFoundException_Thrift epnfe,
                            8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                            9:shared.NetworkErrorException_Thrift nee
                            ),

//******************************** MonitorServer user authentification begin **********************************************************/
    monitorserver.StartPerformanceTaskResponse startPerformanceTask(1:monitorserver.StartPerformanceTaskRequest request) throws(
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.StopPerformanceTaskResponse stopPerformanceTask(1:monitorserver.StopPerformanceTaskRequest request) throws(
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.CreatePerformanceTaskResponse createPerformanceTask(1:monitorserver.CreatePerformanceTaskRequest request) throws(
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: monitorserver.PerformanceTaskIsRudundantException_Thrift ptire,
                                                                                        5: shared.PermissionNotGrantException_Thrift png,
                                                                                        6: shared.AccountNotFoundException_Thrift anf,
                                                                                        7:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        9:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.DeletePerformanceTaskResponse deletePerformanceTask(1:monitorserver.DeletePerformanceTaskRequest request) throws(
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.ListPerformanceTaskResponse listPerformanceTask(1:monitorserver.ListPerformanceTaskRequest request) throws(
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),


    monitorserver.ListCompressedPerformanceByCountResponse listCompressedPerformanceByCount(1: monitorserver.ListCompressedPerformanceByCountRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.ListMultiCompressedPerformanceDataResponse listMultiCompressedPerformanceData(1: monitorserver.ListMultiCompressedPerformanceDataRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: monitorserver.PerformanceDataTimeSpanIsBigException_Thrift pdtsibe,
                                                                                        5: monitorserver.PerformanceDataTimeCrossBorderException_Thrift pdtcbe,
                                                                                        6: shared.PermissionNotGrantException_Thrift png,
                                                                                        7: shared.AccountNotFoundException_Thrift anf,
                                                                                        8:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        9:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        10:shared.NetworkErrorException_Thrift nee
                                                                                        ),

    monitorserver.GetAlertTemplateResponse getAlertTemplate(1:monitorserver.GetAlertTemplateRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.CreateAlertRuleResponse createAlertRule(1:monitorserver.CreateAlertRuleRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: monitorserver.CounterKeyExitedException_Thrift ckee,
                                                                                        5: shared.PermissionNotGrantException_Thrift png,
                                                                                        6: shared.AccountNotFoundException_Thrift anf,
                                                                                        7:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        9:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.DeleteAlertRuleResponse deleteAlertRule(1:monitorserver.DeleteAlertRuleRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.MergeAlertRuleResponse mergeAlertRule(1: monitorserver.MergeAlertRuleRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.UpdateAlertRuleResponse updateAlertRule(1: monitorserver.UpdateAlertRuleRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),

    monitorserver.EnableAlertRuleResponse enableAlertRule(1: monitorserver.EnableAlertRuleRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),

    monitorserver.DisableAlertRuleResponse disableAlertRule(1: monitorserver.DisableAlertRuleRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),

    monitorserver.AlertsAcknowledgeResponse alertsAcknowledge(1: monitorserver.AlertsAcknowledgeRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.ClearAlertsAcknowledgeResponse clearAlertsAcknowledge(1: monitorserver.ClearAlertsAcknowledgeRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.AlertsClearResponse alertsClear(1: monitorserver.AlertsClearRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.DeleteAlertResponse deleteAlert(1: monitorserver.DeleteAlertRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.DeleteAlertsResponse deleteAlerts(1: monitorserver.DeleteAlertsRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.GetAlertMessageDetailResponse getAlertMessageDetail(1: monitorserver.GetAlertMessageDetailRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.ListAlertsByTableResponse listAlertsByTable(1: monitorserver.ListAlertsByTableRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.ListAlertCountResponse listAlertCount(1: monitorserver.ListAlertCountRequest request) throws(
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),


    monitorserver.SaveSnmpForwardItemResponse saveSnmpForwardItem(1: monitorserver.SaveSnmpForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: monitorserver.DuplicateIpPortException_Thrift dupe,
                                                                                        5: shared.PermissionNotGrantException_Thrift png,
                                                                                        6: shared.AccountNotFoundException_Thrift anf,
                                                                                        7:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        9:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.UpdateSnmpForwardItemResponse updateSnmpForwardItem(1: monitorserver.UpdateSnmpForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: monitorserver.DuplicateIpPortException_Thrift dupe,
                                                                                        5: shared.PermissionNotGrantException_Thrift png,
                                                                                        6: shared.AccountNotFoundException_Thrift anf,
                                                                                        7:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        9:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.DeleteSnmpForwardItemResponse deleteSnmpForwardItem(1: monitorserver.DeleteSnmpForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        6: shared.AccountNotFoundException_Thrift anf,
                                                                                        7:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        8:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        9:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.ListSnmpForwardItemResponse listSnmpForwardItem(1: monitorserver.ListSnmpForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),

    monitorserver.SaveEmailForwardItemResponse saveEmailForwardItem(1: monitorserver.SaveEmailForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.UpdateEmailForwardItemResponse updateEmailForwardItem(1: monitorserver.UpdateEmailForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.DeleteEmailForwardItemResponse deleteEmailForwardItem(1: monitorserver.DeleteEmailForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.ListEmailForwardItemResponse listEmailForwardItem(1: monitorserver.ListEmailForwardItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),

    monitorserver.SaveOrUpdateSmtpItemResponse saveOrUpdateSmtpItem(1: monitorserver.SaveOrUpdateSmtpItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.GetSmtpItemResponse getSmtpItem(1: monitorserver.GetSmtpItemRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.IllegalParameterException_Thrift ipe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),
    monitorserver.CheckSmtpSendEmailResponse checkSmtpSendEmail(1: monitorserver.CheckSmtpSendEmailRequest request) throws (
                                                                                        1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                        2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                        3: monitorserver.SmtpSendEmailException_Thrift spe,
                                                                                        4: shared.PermissionNotGrantException_Thrift png,
                                                                                        5: shared.AccountNotFoundException_Thrift anf,
                                                                                        6:shared.EndPointNotFoundException_Thrift epnfe,
                                                                                        7:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                                                                        8:shared.NetworkErrorException_Thrift nee
                                                                                        ),

    monitorserver.ListNotUsedCounterKeyResponse_Thrift listNotUsedCounterKey(1:monitorserver.ListNotUsedCounterKeyRequest_Thrift request) throws (
                                                                                         1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                         2: shared.ServiceIsNotAvailable_Thrift sina),

    VerifyReportStatisticsPermissionResponse verifyReportStatisticsPermission(1: VerifyReportStatisticsPermissionRequest request) throws (
                                                                                              1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              3: shared.PermissionNotGrantException_Thrift png,
                                                                                              4: shared.AccountNotFoundException_Thrift anf),
    icshared.GetDashboardInfoResponse getDashboardInfo(1: icshared.GetDashboardInfoRequest request) throws (
                                                                                              1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                              2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                              3: shared.PermissionNotGrantException_Thrift png,
                                                                                              4: shared.AccountNotFoundException_Thrift anf),



//******************************** MonitorServer user authentification end   **********************************************************/
    void startAutoRebalance() throws (1: shared.NetworkErrorException_Thrift nee),

    void pauseAutoRebalance() throws (1: shared.NetworkErrorException_Thrift nee),

    bool rebalanceStarted() throws (1: shared.NetworkErrorException_Thrift nee),

    void addRebalanceRule(1: shared.AddRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorException_Thrift nee,
                            2: shared.RebalanceRuleExistingException_Thrift rreet),

    shared.DeleteRebalanceRuleResponse deleteRebalanceRule(1: shared.DeleteRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorException_Thrift nee,
                            2: shared.RebalanceRuleNotExistException_Thrift rreet),

    shared.GetRebalanceRuleResponse getRebalanceRule(1: shared.GetRebalanceRuleRequest request) throws (1: shared.NetworkErrorException_Thrift nee),

    void updateRebalanceRule(1: shared.UpdateRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorException_Thrift nee,
                            2: shared.RebalanceRuleNotExistException_Thrift rreet),

    shared.GetAppliedRebalanceRulePoolResponse getAppliedRebalanceRulePool(1: shared.GetAppliedRebalanceRulePoolRequest request) throws (
                            1: shared.NetworkErrorException_Thrift nee,
                            2: shared.StoragePoolNotExistedException_Thrift spneet,
                            3: shared.RebalanceRuleNotExistException_Thrift rreet),

    shared.GetUnAppliedRebalanceRulePoolResponse getUnAppliedRebalanceRulePool(1: shared.GetUnAppliedRebalanceRulePoolRequest request) throws (
                            1: shared.NetworkErrorException_Thrift nee,
                            2: shared.StoragePoolNotExistedException_Thrift spneet),

    void applyRebalanceRule(1: shared.ApplyRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorException_Thrift nee,
                            2: shared.StoragePoolNotExistedException_Thrift spneet,
                            3: shared.PoolAlreadyAppliedRebalanceRuleException_Thrift paarret,
                            4: shared.RebalanceRuleNotExistException_Thrift rreet),

    void unApplyRebalanceRule(1: shared.UnApplyRebalanceRuleRequest request) throws (
                            1: shared.NetworkErrorException_Thrift nee,
                            2: shared.StoragePoolNotExistedException_Thrift spneet,
                            3: shared.RebalanceRuleNotExistException_Thrift rreet),

    shared.CleanOperationInfoResponse cleanOperationInfo(1: shared.CleanOperationInfoRequest request) throws (
                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                            2:shared.ServiceIsNotAvailable_Thrift sina),

    shared.InstanceIncludeVolumeInfoResponse getInstanceIncludeVolumeInfo(1: shared.InstanceIncludeVolumeInfoRequest request) throws (
                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                            2:shared.ServiceIsNotAvailable_Thrift sina),

    shared.EquilibriumVolumeResponse setEquilibriumVolumeStartOrStop(1: shared.EquilibriumVolumeRequest request) throws (
                            1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                            2:shared.ServiceIsNotAvailable_Thrift sina),

    CreateSCSIClientResponse createSCSIClient(1: CreateSCSIClientRequest request) throws (
                                1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                2:shared.ServiceIsNotAvailable_Thrift sina,
                                3:shared.ScsiClientIsExistException_Thrift scieet,
                                4:shared.AccountNotFoundException_Thrift anf,
                                5:shared.PermissionNotGrantException_Thrift png),

    DeleteSCSIClientResponse deleteSCSIClient(1: DeleteSCSIClientRequest request) throws (
                                1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                2:shared.ServiceIsNotAvailable_Thrift sina,
                                3:shared.AccountNotFoundException_Thrift anf,
                                4:shared.PermissionNotGrantException_Thrift png),

    ListSCSIClientResponse listSCSIClient(1: ListSCSIClientRequest request) throws (
                                1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                2:shared.ServiceIsNotAvailable_Thrift sina,
                                3:shared.EndPointNotFoundException_Thrift epnf,
                                4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                5:shared.NetworkErrorException_Thrift nme),
   shared.LaunchDriverResponse_Thrift launchDriverForScsi(1:shared.LaunchScsiDriverRequest_Thrift request) throws (
                                1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                2:shared.ServiceIsNotAvailable_Thrift sina,
                                3:shared.PermissionNotGrantException_Thrift png,
                                4:shared.AccountNotFoundException_Thrift anf,
                                5:shared.ScsiClientIsNotOkException_Thrift scinoe),

    shared.UmountScsiDriverResponse_Thrift umountDriverForScsi(1:shared.UmountScsiDriverRequest_Thrift request) throws (
                                1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                2:shared.ServiceIsNotAvailable_Thrift sina,
                                3:shared.PermissionNotGrantException_Thrift png,
                                4:shared.AccountNotFoundException_Thrift anf
                                5:shared.ScsiClientIsNotOkException_Thrift scinoe),

    icshared.ReportSCSIDriverMetadataResponse reportSCSIDriverMetadata(1:icshared.ReportSCSIDriverMetadataRequest request) throws (
                               1:shared.InternalError_Thrift ie,
                               2:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                               3:shared.ServiceIsNotAvailable_Thrift sina),

    icshared.ListSCSIDriverMetadataResponse listSCSIDriverMetadata(1:icshared.ListSCSIDriverMetadataRequest request) throws (
                                  1:shared.InternalError_Thrift ie,
                                  2:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                  3:shared.ServiceIsNotAvailable_Thrift sina),

   shared.GetDiskSmartInfoResponse_Thrift getDiskSmartInfo(1:shared.GetDiskSmartInfoRequest_Thrift request) throws (
                                    1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                    2:shared.ServiceIsNotAvailable_Thrift sina,
                                    3:shared.EndPointNotFoundException_Thrift epnfe,
                                    4:shared.TooManyEndPointFoundException_Thrift tmepfe,
                                    5:shared.NetworkErrorException_Thrift nee,
                                    6:shared.ServerNodeNotExistException_Thrift snnee,
                                    7:shared.DiskNameIllegalException_Thrift dnie),

   shared.UpdateDiskLightStatusByIdResponse_Thrift updateDiskLightStatusById(1:shared.UpdateDiskLightStatusByIdRequest_Thrift request) throws(
                                    1:shared.ServiceHavingBeenShutdown_Thrift shbs,
                                    2:shared.ServiceIsNotAvailable_Thrift sina),

    GetSegmentSizeResponse getSegmentSize(),
}
