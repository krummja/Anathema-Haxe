package domain.terrain;

import common.struct.Coordinate;
import common.struct.IntPoint;
import domain.Zone;
import domain.prefabs.Spawner;
import engine.TemplateResources;
import hxd.Rand;

class ZoneGen {
	private var seed(get, null): Int;
	private var world(get, null): World;

	public function new() {}

	public function generate(zone: Zone) {
		var r = new Rand(seed + zone.zoneId);

		// Fill the zone grid with its base tile
		zone.cells.fillFn((idx) -> generateCell(r, zone, idx));

		for (gridItem in zone.cells) {
			var worldPos = zone.worldPos.add(gridItem.pos);

			if (
				gridItem.value.terrain != TERRAIN_WATER &&
				r.bool(0.01)
			) {
				// Spawn creatures from biome's creature table
				if (r.bool(0.2)) {
					var biome = Biomes.get(gridItem.value.biomeKey);
					var e = biome.creatures.pick(r);
					if (e != null) {
						Spawner.spawn(e, worldPos.asWorld());
					}
				}
			}

			// Spawn all static entities for the given biome
			var b = Biomes.get(gridItem.value.biomeKey);
			var cell = gridItem.value;
			b.spawnEntity(worldPos, cell);
		}

		var testTemplate = TemplateResources.get(Test);
		var templatePos = new Coordinate(30, 30, WORLD);

		// Clear space for the template
		var entities = [];
		for (x in templatePos.x.floor()...templatePos.x.floor() + testTemplate.width) {
			for (y in templatePos.y.floor()...templatePos.y.floor()
				+ testTemplate.height) {
				for (entity in world.getEntitiesAt(new IntPoint(x, y))) {
					entities.push(entity);
				}
			}
		}

		for (entity in entities) {
			entity.destroy();
		}

		// Map the template colors to tile types
		testTemplate.paint([
			0xffffff.toHxdColor().toString() => FLOOR,
			0xff00ff.toHxdColor().toString() => WALL,
		]);

		// Place the template in the zone
		testTemplate.materialize(templatePos);
	}

	public function generateCell(r: Rand, zone: Zone, idx: Int) {
		var pos = zone.getCellCoord(idx);

		// Make this dynamic instead of hard-coding the biome
		var biome = Biomes.get(PRAIRIE);

		var cell: Cell = {
			idx: idx,
			terrain: TERRAIN_GRASS,
			biomeKey: PRAIRIE,
			tileKey: TK_GRASS_01,
			primary: C_GREEN_3,
			secondary: C_BLACK,
			background: C_BLACK,
		};

		var worldPos = pos.add(zone.worldPos);

		biome.setCellData(worldPos, cell);

		return cell;
	}

	private function get_seed(): Int {
		return World.instance.seed;
	}

	private function get_world(): World {
		return World.instance;
	}
}
