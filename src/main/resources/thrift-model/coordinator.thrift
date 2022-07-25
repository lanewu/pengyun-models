
include "shared.thrift"
include "icshared.thrift"

/**
 * This thrift file defines coordinator service and its client
 */
namespace java py.thrift.coordinator.service

/**
 * Request coordinator to update volume information once done extending volume.
 */
struct UpdateVolumeOnExtendingRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: optional i64 accountId,
    4: optional i64 extendingSize,
}

struct UpdateVolumeOnExtendingResponse {
    1: i64 requestId
}

struct AddOrModifyLimitationRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: shared.IOLimitation_Thrift ioLimitation
}

struct AddOrModifyLimitationResponse {
    1: i64 requestId,
}

struct DeleteLimitationRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: i64 ioLimitationId
}

struct DeleteLimitationResponse {
    1: i64 requestId
}

/**
 * Slow down if you are not the coordinator of the volume with the given volume id
 */
struct SlowDownRequest {
    1: i64 requestId,
    2: i32 slowDownLevel,
    3: i64 volumeId
}

struct SlowDownResponse {
    1: i64 requestId,
}

struct ResetSlowLevelRequest {
    1: i64 requestId,
    2: i64 volumeId
}

struct ResetSlowLevelResponse {
    1: i64 requestId
}

struct ShutdownRequest {
    1: i64 requestId,
    2: bool graceful,
}

enum UpdateSnapshotRequestType {
    Create = 1,
    Delete = 2,
    Rollback = 3
}

struct UpdateSnapshotRequest {
    1: i64 requestId,
    2: UpdateSnapshotRequestType type,
    3: optional shared.SnapshotMetadataV2_Thrift snapshot,
    4: optional i32 snapshotId
}

struct UpdateSnapshotResponse {
    1: i64 requestId,
    2: i32 snapshotId
}

struct CreateSnapshotRequest {
    1: i64 requestId,
    2: shared.SnapshotMetadataV2_Thrift snapshot
}

struct CreateSnapshotResponse {
    1: i64 requestId,
    2: i32 snapshotId
}

enum SnapshotVersionStatus {
    Created = 1,
    Committed = 2,
    Aborted = 3
}

struct QuerySnapshotVersionStatusResponse {
    1: i32 currentVersion,
    2: SnapshotVersionStatus status
}

exception VersionTooOldException_Thrift {
    1: i32 currentVersion
}

exception UnstableLeaderException_Thrift {
}
struct GetStartupStatusRequest {
    1: i64 requestId,
    2: i64 volumeId,
    3: i32 snapshotId
}

struct GetStartupStatusResponse {
    1: i64 requestId,
    2: bool startupStatus
}

service Coordinator extends shared.DebugConfigurator {

   // Healthy?
   void ping(),
   
   void discardAll(),

   bool discardingAll(),

   void stopDiscardingAll(),

   //  Shutdown graceful or not
   void shutdown(1: ShutdownRequest request) throws (
                                             1:shared.ServiceHavingBeenShutdown_Thrift shbsd),


   // update volume information once done extending volume
   UpdateVolumeOnExtendingResponse updateVolumeOnExtending(1: UpdateVolumeOnExtendingRequest request),

   // modify limitation
   AddOrModifyLimitationResponse addOrModifyLimitation(1: AddOrModifyLimitationRequest request),

   // delete an limitation item
   DeleteLimitationResponse deleteLimitation(1: DeleteLimitationRequest request),

   // Slow down if you are not the coordinator of the volume with the given volume id
   SlowDownResponse slowDownExceptFor(1: SlowDownRequest request),

   // Reset the slow level
   ResetSlowLevelResponse resetSlowLevel(1: ResetSlowLevelRequest request),
    
   // for snapshot

   CreateSnapshotResponse createSnapshot(1:CreateSnapshotRequest request) throws (
                           1:shared.SnapshotExistException_Thrift see,
                           2:shared.InternalError_Thrift ie),

   UpdateSnapshotResponse updateSnapshot2(1:UpdateSnapshotRequest request) throws (
                           1:shared.InternalError_Thrift ie),

   bool broadcastPublishNewSnapshotVersion(1:i64 volumeId, 2:i32 snapshotVersion) throws (
                           1:shared.InternalError_Thrift ie),

   bool broadcastCommitNewSnapshotVersion(1:i64 volumeId, 2:i32 snapshotVersion, 3:i32 leaseMS) throws (
                           1:shared.InternalError_Thrift ie,
                           2:VersionTooOldException_Thrift vtoe),

   bool broadcastAbortSnapshotVersion(1:i64 volumeId, 2:i32 snapshotVersion) throws (
                           1:shared.InternalError_Thrift ie),

   QuerySnapshotVersionStatusResponse querySnapshotVersionStatus(1:i64 volumeId),

   shared.UpdateSnapshotVersionResponse updateSnapshot(1:shared.UpdateSnapshotVersionRequest request) throws (
                           1:shared.ServiceHavingBeenShutdown_Thrift shbsd),

   shared.ApplyVolumeAccessRulesToDriverResponse applyVolumeAccessRules(1:shared.ApplyVolumeAccessRulesToDriverRequest request) throws (
                                                                       1:shared.ServiceHavingBeenShutdown_Thrift shbsd),

   shared.CancelVolumeAccessRulesToDriverResponse cancelVolumeAccessRules(1:shared.CancelVolumeAccessRulesToDriverRequest request) throws (
                                                                          1:shared.ServiceHavingBeenShutdown_Thrift shbsd),

   shared.GetConnectClientInfoResponse getConnectClientInfo(1:shared.GetConnectClientInfoRequest request) throws (
                                                                          1:shared.ServiceHavingBeenShutdown_Thrift shbsd),

   shared.GetDriverConnectPermissionResponse_Thrift  getDriverConnectPermission(1:shared.GetDriverConnectPermissionRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd),

   shared.ShowIOResponse_Thrift showIO(1:shared.ShowIORequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd),

   shared.ChangeIOPathResponse_Thrift ChangIOPath(1:shared.ChangeIOPathRequest_Thrift request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                                       2:shared.MoveOnlineTheVolumeHasInitException_Thrift motvhie),
   GetStartupStatusResponse getStartupStatus(1:GetStartupStatusRequest request) throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd),
}

