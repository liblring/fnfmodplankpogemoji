package windowblinds;

@:publicFields
class WindowblindDragFlags {
	static inline final NONE:Int = 0;
	static inline final LEFT:Int = 1;
	static inline final TOP:Int = 2;
	static inline final RIGHT:Int = 4;
	static inline final BOTTOM:Int = 8;
	static inline final TOPLEFT:Int = TOP | LEFT;
	static inline final TOPRIGHT:Int = TOP | RIGHT;
	static inline final BOTTOMLEFT:Int = BOTTOM | LEFT;
	static inline final BOTTOMRIGHT:Int = BOTTOM | RIGHT;
}