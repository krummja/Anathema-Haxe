package ecs;

interface EntityZoneTracker {
	function onEntityMoved(entity: Entity, prevZoneIdx: Int, nextZoneIdx: Int): Void;
	function onEntityDestroyed(entity: Entity, zoneIdx: Int): Void;
}
