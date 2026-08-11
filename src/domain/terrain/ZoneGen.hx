package domain.terrain;

import common.struct.Coordinate;
import common.struct.IntPoint;
import domain.Zone;
import engine.TemplateResources;
import hxd.Rand;

class ZoneGen {
	private var seed(get, null): Int;
	private var world(get, null): World;

	public function new() {}

	public function generate(zone: Zone) {
		var r = new Rand(seed + zone.zoneId);

		zone.cells.fillFn((idx) -> generateCell(r, zone, idx));

		for (gridItem in zone.cells) {
			var worldPos = zone.worldPos.add(gridItem.pos);

			var b = Biomes.get(gridItem.value.biomeKey);
			var cell = gridItem.value;
			b.spawnEntity(worldPos, cell);
		}

		var testTemplate = TemplateResources.get(Test);
		var templatePos = new Coordinate(30, 30, WORLD);

		var entities = [];
		for (x in templatePos.x.floor()...templatePos.x.floor() + testTemplate.width) {
			for (y in templatePos.y.floor()...templatePos.y.floor() + testTemplate.height) {
				for (entity in world.getEntitiesAt(new IntPoint(x, y))) {
					entities.push(entity);
				}
			}
		}

		for (entity in entities) {
			entity.destroy();
		}

		testTemplate.paint([
			0xffffff.toHxdColor().toString() => FLOOR,
			0xff00ff.toHxdColor().toString() => WALL,
		]);

		testTemplate.materialize(templatePos);
	}

	public function generateCell(r: Rand, zone: Zone, idx: Int) {
		var pos = zone.getCellCoord(idx);
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
