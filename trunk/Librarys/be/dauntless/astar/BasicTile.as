/*
Copyright (c) 2008 Jeroen Beckers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/


package be.dauntless.astar 
{
	import flash.geom.Point;	
	
	import be.dauntless.astar.IPositionTile;
	
	/**
	 * Provides basic implementation for the IPositionTile, IWalkable and ICostTile interfaces
	 * @author Jeroen
	 */
	public class BasicTile implements IPositionTile, IWalkableTile, ICostTile
	{
		private var position : Point;
		private var cost:Number;
		private var walkable:Boolean;

		public function BasicTile(cost:Number, position:Point, walkable:Boolean)
		{
			this.cost = cost;
			this.position = position;
			this.walkable = walkable;
		}
		public function getPosition() : Point
		{
			return position;
		}
		
		public function setPosition(p : Point) : void
		{
			position = p;
		}
		
		public function getWalkable() : Boolean
		{
			return walkable;
		}
		
		public function setWalkable(walkable : Boolean) : void
		{
			this.walkable = walkable;
		}
		
		public function getCost() : Number
		{
			return cost;
		}
		
		public function setCost(cost : Number) : void
		{
			this.cost = cost;
		}
	}
}
