package{
        /*
        iiacm(�Ż�����)����ҳ��Ϸ������ www.eb163.com 
        ��ҳ��Ϸ��������
        
        A*Ѱ·����ڵ���
                ΪѰ·�ṩ���ݽڵ����
        */
        import flash.display.DisplayObject;
        public class AStarGrid{
                //�ڵ�ĸ��ڵ�
                public var father:AStarGrid;
                //�ڵ����ڵ��к�
                public var dR:uint;
                //�ڵ����ڵ��к�
                public var dC:uint;
                //�ڵ��Ӧ�ĵ�ͼ��Ԫ
                public var mc:DisplayObject;
                //�Ӵ˽ڵ㵽Ŀ��ڵ�Ĺ����ƶ�����
                public var h:uint=0;
                //�����������������ɵ�·�����˽ڵ���ƶ�����
                public var g:uint=0;
                //�ڵ���ƶ����������������˽ڵ��·�����ȶ�
                public var f:uint=0;
                //���캯������ʼ���ڵ��ֵ
                public function AStarGrid(dataR:uint=0, dataC:uint=0, displayObj:DisplayObject=null, father=null){
                        father=father;
                        dR=dataR;
                        dC=dataC;
                        mc=displayObj;
                }
        }
}