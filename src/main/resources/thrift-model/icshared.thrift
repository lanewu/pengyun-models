include "shared.thrift"

namespace java py.thrift.icshare
namespace perl icshare

//********** List Volumes Request ******************************/
struct ListVolumesRequest {
   1: i64 requestId,
   2: i64 accountId,
   // tagA=value1,tagA=value2,tagB=value3 means querying volumes whose (tagA is value1 or value2) and tagB is value3
//   3: optional list<shared.Tag> query
   3: optional set<i64> volumesCanBeList,
   4: optional bool containDeadVolume
}

struct ListAllSnapshotsRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: optional set<i64> volumeIds
}

struct ListAllSnapshotsResponse {
    1: i64 requestId,
    2: map<shared.VolumeMetadata_Thrift, binary> volume2SnapshotManagerBinary,
    3: map<i64, map<i32, i64>> volumeId2SnapshotId2Capacity,
    4: map<i64, i64> volumeId2TotalCapacity
}

struct ListAllDriversRequest{
   1:i64 requestId,
   2:optional i64 volumeId,
   3:optional i32 snapshotId,
   4:optional string drivercontainerHost,
   5:optional string driverHost,
   6:optional shared.DriverType_Thrift driverType
}

struct ListAllDriversResponse{
   1:i64 requestId,
   2:list<shared.DriverMetadata_Thrift> driverMetadatas_thrift
}

struct ListVolumesResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadata_Thrift> volumes
}
//******** End of ListVolumesRequest *****/

//********** Get Volume Request ******************************/
struct GetVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId,
   4: string name,
   5: bool withOutSegmentList,
   6: optional bool containDeadVolume,
   7: optional bool enablePagination,
   8: optional i32 startSegmentIndex,
   9: optional i32 paginationNumber
}

struct GetVolumeResponse {
   1: i64 requestId,
   2: optional shared.VolumeMetadata_Thrift volumeMetadata,
   3: list<shared.DriverMetadata_Thrift> driverMetadatas,
   4: optional list<shared.Tag> tags,
   5: optional bool leftSegment,
   6: optional i32 nextStartSegmentIndex
}

struct GetRootVolumeWithChildrenRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct GetRootVolumeWithChildrenResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadata_Thrift> rootVolumeWithChildren,
}

struct GetDriversRequest_Thrift {
   1: i64 requestId,
   2: i64 volumeId
}

struct GetDriversResponse_Thrift {
   1: i64 requestId,
   2: list<shared.DriverMetadata_Thrift> drivers
}

//******** End of GetVolumeRequest *****/


//********** list SegmentMetadata status *************/
struct GetSegmentMetadataStatusRequest {
   1: i64 requestId,
   2: i64 volumeId
}

struct GetSegmentMetadataStatusResponse {
   1: i64 requestId,
   2: map<i32, shared.SegmentStatus_Thrift> segmentMetadataStatus
}

//********** end list SegmentMetadata status **********/


//********** Report DriverMetadata Request *************/
struct ReportDriverMetadataRequest {
    1:i64 requestId,
    2:optional i64 drivercontainerId,
    3:list<shared.DriverMetadata_Thrift> drivers,
    4:optional i64 driverId
}

struct ReportDriverMetadataResponse {
    1:i64 requestId,
    2:optional list<i64> confictVolumeIds
}
//*********** End *****************************/

//********** Report DriverMetadata Request *************/
enum SCSIClientStatus_Thrift {
    OK = 1,
    ERROR = 2
}

enum SCSIDescriptionType_Thrift {
    LaunchDriver = 1,
    UmountDriver = 2
}

struct SCSIClientDescription_Thrift {
    1: string ip,
    2: SCSIClientStatus_Thrift status
}

struct SCSIClientInfo_Thrift {
    1: shared.VolumeMetadata_Thrift volume,
    2: shared.DriverStatus_Thrift driverStatus,
    3: shared.ScsiDeviceStatus_Thrift status,
    4: string path,
    5: string statusDescription,
    6: SCSIDescriptionType_Thrift descriptionTpye
}

struct SCSIClientInfoForEachClient_Thrift {
    1: i64 volumeId,
    2: shared.ScsiDeviceStatus_Thrift status,
    3: string path
    }

struct SCSIDeviceInfo_Thrift {
    1:i64 volumeId,
    2:i32 snapshotId,
    3:string driverIp,
    4:shared.ScsiDeviceStatus_Thrift scsiDeviceStatus,
    5:string scsiDevice
}

struct ReportSCSIDriverMetadataRequest {
    1:i64 requestId,
    2:i64 drivercontainerId,
    3:list<SCSIDeviceInfo_Thrift> scsiList
}

struct ReportSCSIDriverMetadataResponse {
    1:i64 requestId
}

struct ListSCSIDriverMetadataRequest {
 1:i64 requestId,
 2:map<i64, i32> volumeInfo,
 3:string driverIp,
 4:i64 driverContainerIdScsi,
 5:set<i64> driverContainersIdWithPyd
}

struct ListSCSIDriverMetadataResponse {
    1:i64 requestId,
    2:string driverIp,
    3:list<SCSIClientInfo_Thrift> scsiClientInfo,
    4:list<shared.VolumeMetadata_Thrift> unUsedVolumeInfos,
    5:list<shared.DriverMetadata_Thrift> driverInfo
}

struct ListArchivesResponse_Thrift {
   1: i64 requestId,
   2: list<shared.InstanceMetadata_Thrift> instanceMetadata
}

struct GetArchivesResponse_Thrift {
   1: i64 requestId,
   2: shared.InstanceMetadata_Thrift instanceMetadata
}

struct ListArchivesRequest_Thrift {
   1: i64 requestId
}

struct ListArchivesAfterFilterRequest_Thrift {
   1: i64 requestId
}

struct ListArchivesAfterFilterResponse_Thrift {
   1: i64 requestId
   2: list<shared.InstanceMetadata_Thrift> instanceMetadata
}

struct GetArchivesRequest_Thrift {
   1: i64 requestId,
   2: i64 instanceId
}

struct GetArchiveRequest_Thrift {
   1: i64 requestId,
   2: list<i64> archiveIds
}

struct GetArchiveResponse_Thrift {
   1: i64 requestId,
   2: list<shared.InstanceMetadata_Thrift> instanceMetadata
}

struct DeleteVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: string volumeName,
   4: i64 accountId
}

struct DeleteVolumeResponse {
   1: i64 requestId
}

struct CreateVolumeRequest {
   1:i64 requestId,
   2:i64 rootVolumeId,
   3:i64 volumeId,
   4:string name,
   5:i64 volumeSize,
   6:i64 segmentSize,
   7:shared.VolumeType_Thrift volumeType,
   8:optional shared.CacheType_Thrift cacheType,
   9:i64 accountId,
   10:list<shared.Tag> tags,
   11:i64 domainId,
   12:i64 storagePoolId,
   13: optional bool notCreateAllSegmentAtBegining, // mark create all segment at the beginning
   14: optional i32 leastSegmentUnitCount, // if not create all segment at the beginning, the least segment unit should be created
   15: bool simpleConfiguration,
   16: string requestType,
   17:optional shared.WtsType_Thrift wtsType,
   18: bool enableLaunchMultiDrivers,
   19: optional string srcVolumeNameWithClone,
   20: optional string srcSnapshotNameWithClone
}

struct CreateVolumeResponse {
   1: i64 requestId,
   2: i64 volumeId
}

struct MoveVolumeRequest {
   1:i64 requestId,
   2:i64 srcVolumeId,
   3:i64 rootVolumeId,
   4:i32 snapshotId,
   5:i64 accountId,
   6:i64 targetVolumeId,
   7:i64 targetDomainId,
   8:i64 targetStoragePoolId,
   9: shared.WtsType_Thrift wtsType
}
struct MoveVolumeResponse {
   1:i64 requestId,
   2:i64 newVolumeId
}

struct MoveVolumeOnlineRequest {
    1:i64 requestId,
    2:i64 srcVolumeId,
    3:i64 rootVolumeId,
    4:i32 snapshotId,
    5:i64 accountId,
    6:i64 targetVolumeId,
    7:i64 targetDomainId,
    8:i64 targetStoragePoolId,
    9: shared.WtsType_Thrift wtsType
}
struct MoveVolumeOnlineResponse {
    1:i64 requestId,
    2:i64 newVolumeId
}

struct UpdateVolumeRequest {
   1:i64 requestId,
   2:i64 volumeId,
   3:i64 accountId,
   4:optional string newVolumeName,
   5:optional shared.VolumeInAction_Thrift volumeInAction
}

struct UpdateVolumeResponse {
   1:i64 requestId,
}

struct GetVolumeCloneStatusMoveOnlineRequest {
   1:i64 requestId,
   2:i64 volumeId,
   3:i64 accountId
}

struct GetVolumeCloneStatusMoveOnlineRequestResponse {
   1:i64 requestId,
   2:bool cloneStatus
}

struct CloneVolumeRequest {
   1: i64 requestId,
   2: i64 srcVolumeId,
   3: i32 snapshotId,
   4: i64 accountId,
   5: string name,
   6: i64 domainId,
   7: i64 storagePoolId,
   8: i64 rootVolumeId,
   9: shared.CloneType_Thrift cloneType,
   10: shared.WtsType_Thrift wtsType
   11: bool simpleConfiguration
}

struct CloneVolumeResponse {
   1: i64 requestId,
   2: i64 cloneVolumeId
}

struct CreateSegmentsRequest {
   1: i64 accountId,
   2: i64 requestId,
   3: i64 volumeId,
   4: i32 segmentNum,
   5: i32 segmentIndex,
   6: i64 domainId,
   7: i64 storagePoolId
}

struct CreateSegmentsResponse {
   1: i64 requestId,
}

struct GetLimitsRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 driverContainerId,
   4: shared.DriverType_Thrift driverType,
   5: i32 snapshotId
}

struct GetLimitsResponse {
   1: i64 requestId,
   2: i64 volumeId,
   3: list<shared.IOLimitation_Thrift> ioLimitations,
   4: bool staticLimit
}

struct AddOrModifyIOLimitRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 volumeId,
   4: i64 driverContainerId,
   5: shared.DriverType_Thrift driverType,
   6: i32 snapshotId,
   7: shared.IOLimitation_Thrift ioLimitation
}

struct AddOrModifyIOLimitResponse {
   1: i64 requestId,
   2: string volumeName,
   3: string driverTypeAndEndPoint
}

struct DeleteIOLimitRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 volumeId,
   4: i64 limitId,
   5: i64 driverContainerId,
   6: shared.DriverType_Thrift driverType,
   7: i32 snapshotId
}

struct DeleteIOLimitResponse {
   1: i64 requestId,
   2: string volumeName,
   3: string driverTypeAndEndPoint
}

struct ChangeLimitTypeRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 limitId,
   4: i64 volumeId,
   5: i64 driverContainerId,
   6: shared.DriverType_Thrift driverType,
   7: i32 snapshotId,
   8: bool staticLimit
}

struct ChangeLimitTypeResponse {
   1: i64 requestId,
}

struct RecycleVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

struct RecycleVolumeResponse {
   1: i64 requestId,
}

struct OrphanVolumeRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId
}

/**
*  when MoveVolumeOnline operation should update volume accessrule
*  and iscsi access rule on drivers specified of new volume
*  then sweep thread will use rules on new volumes or drivers
*
*  should create new first then drivercontainer changeDriverBoundVolume
*  at last delete old access rule
*/

struct CreateAccessRuleOnNewVolumeRequest {
    1: i64 requestId,
    2: shared.DriverKey_Thrift driver,
    3: i64 newVolumeId
}

struct CreateAccessRuleOnNewVolumeResponse{
    1: i64 requestId
}

struct DeleteAccessRuleOnOldVolumeRequest {
    1: i64 requestId,
    2: i64 oldVolumeId,
    3: shared.DriverKey_Thrift driver,
}

struct DeleteAccessRuleOnOldVolumeResponse{
    1: i64 requestId
}

struct OrphanVolumeResponse {
   1: i64 requestId,
   2: list<shared.VolumeMetadata_Thrift> orphanVolumes
}

struct GetSegmentListRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 accountId,
   4: i32 startSegmentIndex,
   5: i32 endSegmentIndex
}

struct GetSegmentListResponse {
   1: i64 requestId,
   2: list<shared.SegmentMetadata_Thrift> segments
}

struct GetSegmentRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segmentIndex,
}

struct GetSegmentResponse {
   1: i64 requestId,
   2: shared.SegmentMetadata_Thrift segment,
   3: i64 storagePoolId,
}

##-----------------this below is for dashboard info--------------------##

struct Capacity {
    1: string message,
    2: string totalCapacity,
    3: string availableCapacity,
    4: string usedCapacity,
    5: string freeSpace,
    6: string availableCapacityPer,
    7: string usedCapacityPer;
    8: string theUsedUniPerStr;
    9: string theunUsedUniPerStr;
    10:string theUsedUnitSpace;
    11:string theunUsedUnitSpace;
}

struct VolumeCounts {
    1: string message,
    2: i32 oKCounts,
    3: i32 degreeCounts,
    4: i32 unavailableCounts,
    5: i32 totalClients,
    6: i32 connectedClients;
}

struct InstanceStatusStatistics {
    1: i32 serviceOK,
    2: i32 serviceINC,
    3: i32 serviceFailed,
    4: i32 serviceTotal;
    5: string message;
}

struct ClientTotal {
    1: string message,
    2: i32 clientTotal;
}

struct PoolStatistics {
    1: i32 poolHigh,
    2: i32 poolMiddle,
    3: i32 poolLow,
    4: i32 poolTotal;
    5: string message;
}

struct DiskStatistics {
    1: i32 goodDiskCount,
    2: i64 badDiskCount,
    3: i64 allDiskCount;
    4: string message;
}

struct AlertStatistics {
    1: i32 criticalAlertCount,
    2: i32 majorAlertCount,
    3: i32 minorAlertCount,
    4: i32 warningAlertCount,
    5: i32 clearedAlertCount;
    6: string message;
}

struct ServerNodeStatistics {
    1: i32 okServerNodeCounts,
    2: i32 unknownServerNodeCount,
    3: i32 totalServerNodeCount;
    4: string message;
}

struct GetDashboardInfoRequest {
    1: i64 requestId,
    2: i64 accountId;
}

struct GetDashboardInfoResponse {
    1: i64 responseId,
    2: Capacity capacity,
    3: VolumeCounts volumeCounts,
    4: InstanceStatusStatistics instanceStatusStatistics,
    5: ClientTotal clientTotal,
    6: PoolStatistics poolStatistics,
    7: DiskStatistics diskStatistics,
    8: AlertStatistics alertStatistics,
    9: ServerNodeStatistics serverNodeStatistics;
}

##-----------------this above is for dashboard info--------------------##