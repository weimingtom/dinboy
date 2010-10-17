package ruby.winTable
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;

	public class warnBox extends UIComponent
	{
		private var m_box:warningBox;
		public var m_Ok:SimpleButton;
		public var m_NO:SimpleButton;
		public function warnBox()
		{
			super();
			m_box = new warningBox();
			addChild(m_box);
			m_NO = m_box.m_NO;
			m_Ok = m_box.m_OK;
			this.x = 300;
			this.y = 230;
		//	m_OK.addEventListener(MouseEvent.CLICK,YESHandler);
		//	m_NO.addEventListener(MouseEvent.CLICK,NOHandler);
		}
	
		
	}
}