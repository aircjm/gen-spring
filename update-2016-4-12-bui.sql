/* bui模板 */
insert into `template_config` (`name`, `save_path`, `suffix`, `file_name`, `content`, `back_user`) values('1durc-jsp-bui','jsp',NULL,'${context.javaBeanNameLF}.jsp','#set($jq=\"$\")\n<%@ page language=\"java\" contentType=\"text/html; charset=UTF-8\"\n    pageEncoding=\"UTF-8\"%>\n<%@ include file=\"taglib.jsp\" %>\n<c:set var=\"bui\" value=\"${jq}{res}bui/\"/>\n<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n<html>\n <head>\n  <title>后台管理</title>\n   <script type=\"text/javascript\">var ctx = \'${ctx}\';</script>\n   <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n   <link href=\"${jq}{bui}css/dpl-min.css\" rel=\"stylesheet\" type=\"text/css\" />\n   <link href=\"${jq}{bui}css/bui-min.css\" rel=\"stylesheet\" type=\"text/css\" />\n   <link href=\"${jq}{bui}css/page-min.css\" rel=\"stylesheet\" type=\"text/css\" />\n </head>\n<body>\n  \n  <div class=\"container\">\n    <div class=\"row\">\n      <form id=\"searchForm\" class=\"form-horizontal\">\n        <div class=\"row\">         \n      #foreach($column in $columns)\n		#if(!${column.isIdentityPk})\n     <div class=\"control-group span8\">\n            <label class=\"control-label\">${column.javaFieldName}：</label>\n            <div class=\"controls\">\n              <input type=\"text\" class=\"control-text\" name=\"${column.javaFieldName}Sch\">\n            </div>\n          </div>    \n					 #end\n					#end\n\n\n          <div class=\"control-group\">\n            <div class=\"controls\">\n              <button  type=\"button\" id=\"schBtn\" class=\"button button-primary\">搜索</button>\n            </div>\n          </div>\n        </div>\n      </form>\n    </div>\n    <hr>\n    <div class=\"search-grid-container\">\n      <div id=\"grid\"></div>\n    </div>\n  </div>\n  \n   <div id=\"content\" class=\"hide\">\n      <form id=\"J_Form\" class=\"form-horizontal\">        \n		#foreach($column in $columns)\n		 #if(!${column.isIdentityPk})						\n		 <div class=\"row\">\n          <div class=\"control-group span8\">\n            <label class=\"control-label\"><s>*</s>${column.javaFieldName}</label>\n            <div class=\"controls\">\n              <input name=\"${column.javaFieldName}\" data-rules=\"{required:true}\" class=\"input-normal control-text\" type=\"text\"/>\n            </div>\n          </div>\n        </div>\n					   #end\n					#end		\n\n      </form>\n    </div>\n  \n  <script type=\"text/javascript\" src=\"${jq}{bui}js/jquery-1.8.1.min.js\"></script>\n  <script type=\"text/javascript\" src=\"${jq}{bui}js/bui-min.js\"></script>\n  <script type=\"text/javascript\" src=\"${jq}{res}js/common.js\"></script>\n \n<script type=\"text/javascript\">\n${jq}(function(){\n	var TYPE_ADD = \'add\', TYPE_EDIT = \'update\',TYPE_REMOVE = \'remove\';\n    \n	var listUrl = ctx + \'list${context.javaBeanName}.do\'; // 查询\n	var addUrl = ctx + \'add${context.javaBeanName}.do\'; // 添加\n	var updateUrl = ctx + \'update${context.javaBeanName}.do\'; // 修改\n	var delUrl = ctx + \'del${context.javaBeanName}.do\'; // 删除\n	var exportUrl = ctx + \'export${context.javaBeanName}.do\'; // 导出	\n	var ${jq}schBtn = ${jq}(\'#schBtn\'); // 查询按钮\n	\n	var Grid = BUI.Grid;\n	var Store = BUI.Data.Store;\n	var Form = BUI.Form;\n	\n	var grid; // 表格\n	var store; // 数据\n	var schForm; // 查询form\n	var editing;// 编辑表单\n\n    function init() {\n    	initForm();\n    	initData();\n        initEditing();\n    	initGrid();\n    	initEvent();\n    }\n    \n    function initForm() {\n    	var formCfg = {\n	      srcNode : \'#searchForm\' \n	      ,value : {}\n	    };\n	    schForm = new Form.HForm(formCfg);\n	    schForm.render();\n    }\n    \n    function initData() {\n    	store = new Store({\n    		url : listUrl,\n          	autoLoad:true,\n    		totalProperty:\'total\',\n          	pageSize:10,  // 配置分页数目\n          	proxy : {\n	            save : { //也可以是一个字符串，那么增删改，都会往那么路径提交数据，同时附加参数saveType\n	                addUrl : addUrl,\n	                updateUrl : updateUrl,\n	                removeUrl : delUrl\n	            }\n    			,method:\'POST\'\n          	}\n    		\n        });\n    }\n    \n    function initEditing() {\n    	editing = new BUI.Editor.DialogEditor({\n			contentId:\'content\'\n			,form:{srcNode:${jq}(\'#J_Form\')}\n            ,buttons:[\n				{text:\'确定\',elCls : \'button button-primary\',handler : function(){\n	             	save();\n                }}\n              ,{text:\'取消\',elCls : \'button\',handler : function(){\n                	this.close();\n               }}\n			]\n		});\n    }\n    \n    function initGrid() {\n    	var columns = [\n    	   #set($i=0)\n#foreach($column in $columns)\n    #if(!${column.isIdentityPk})    \n    #if($i>0),#end {title:\'${column.javaFieldName}\',dataIndex:\'${column.javaFieldName}\'}\n    #set($i=$i+1)\n    #end    \n#end \n          ,{title:\'操作\',dataIndex:\'\',width:200,renderer : function(value,obj){\n       	   var updateStr = \'<span class=\"grid-command btn-edit\">修改</span>\';\n              var delStr = \'<span class=\"grid-command btn-del\">删除</span>\';\n              return updateStr + delStr;\n            }}\n        ];    	\n    	\n    	grid = new Grid.Grid({\n          	render:\'#grid\'\n          	,columns : columns\n          	,loadMask: true\n          	,store: store\n          	,emptyDataTpl : \'<div class=\"centered\"><h2>查询的数据不存在</h2></div>\'\n          	,tbar : {\n              items : [\n                {text : \'<i class=\"icon-plus\"></i>新建\',btnCls : \'button button-small\',handler:add}\n                ,{text : \'<i class=\"icon-download\"></i>导出\',btnCls : \'button button-small\',handler:exportFile}\n              ]\n            }\n          	// 底部工具栏\n          	,bbar:{\n              	// pagingBar:表明包含分页栏\n              	pagingBar:true\n    		}\n    	});\n\n    	grid.render();\n    }\n    \n    function initEvent() {\n    	 //监听事件，删除一条记录\n        grid.on(\'cellclick\',function(ev){\n        	var sender = ${jq}(ev.domTarget); //点击的Dom\n        	if(sender.hasClass(\'btn-del\')){\n            	var record = ev.record;\n            	del(record);\n        	}\n        	if(sender.hasClass(\'btn-edit\')){\n            	var record = ev.record;\n            	edit(record);\n        	}\n        });\n        \n    	${jq}schBtn.on(\'click\',function(ev){\n           ev.preventDefault();\n           search();\n    	});\n    }\n    \n    \n    //////// functions ////////\n    \n    function search() {\n    	var param = schForm.serializeToObject();\n    	param.start = 0;\n    	store.load(param);\n    }\n    \n    function exportFile() {\n    	var data = schForm.serializeToObject();\n    	ExportUtil.doExport(exportUrl,data);\n    }\n    \n    function save() {\n    	editing.valid();\n    	if(editing.isValid()) {\n    		var editType = editing.get(\'editType\');\n    		var form = editing.get(\'form\');\n    		var curRecord = editing.get(\'record\'); // 表格中的数据\n    		var record = form.serializeToObject(); // 表单数据\n    		\n    		BUI.mix(curRecord,record); // 将record赋值到curRecord中\n    		store.save(editType,curRecord,function(){\n    			store.load();\n    			editing.close();\n    		})\n    	}\n    }\n    \n    function add(){\n        editing.set(\'editType\',TYPE_ADD);\n        showEditor({});\n    }\n    \n    function edit(record) {\n    	editing.set(\'editType\',TYPE_EDIT);\n    	showEditor(record);\n    }\n    \n    function showEditor(record) {\n		editing.set(\'record\',record);\n		editing.show();\n		editing.setValue(record,true); //设置值，并且隐藏错误\n    }\n	\n    function del(record){\n	    if(record){\n	    	BUI.Message.Confirm(\'确认要删除选中的记录么？\',function(){\n	    		store.save(TYPE_REMOVE,record,function(){\n	    			store.load();\n	    		})\n	       	},\'question\');\n	    }\n    }\n    \n    init();\n	\n});\n</script>\n\n</body>\n</html>\n','admin');
