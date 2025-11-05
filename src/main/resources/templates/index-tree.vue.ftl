<template>
  <div class="p-2">
    <transition>
      <div v-show="showSearch" class="mb-[6px]">
        <el-card shadow="hover">
          <el-form ref="queryFormRef" :model="queryParams" :inline="true">
      <#list columns as column>
        <#if column.isQuery>
          <#assign dictCode = column.dictCode>
          <#assign AttrName = column.javaField?substring(0,1)?upper_case + column.javaField?substring(1)>
          <#assign parentheseIndex = column.columnComment?index_of("（")>
          <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
          <#else>
            <#assign comment = column.columnComment>
          </#if>
          <#if column.htmlType == "input" || column.htmlType == "textarea">
            <el-form-item label="${comment}" prop="${column.javaField}">
              <el-input v-model="queryParams.${column.javaField}" placeholder="请输入${comment}" clearable @keyup.enter="handleQuery" />
            </el-form-item>
          <#elseif (column.htmlType == "select" || column.htmlType == "radio") && "" != dictCode>
            <el-form-item label="${comment}" prop="${column.javaField}">
              <el-select v-model="queryParams.${column.javaField}" placeholder="请选择${comment}" clearable>
                <el-option v-for="dict in ${dictCode}" :key="dict.value" :label="dict.label" :value="dict.value"/>
              </el-select>
            </el-form-item>
          <#elseif (column.htmlType == "select" || column.htmlType == "radio") && dictCode>
            <el-form-item label="${comment}" prop="${column.javaField}">
              <el-select v-model="queryParams.${column.javaField}" placeholder="请选择${comment}" clearable>
                <el-option label="请选择字典生成" value="" />
              </el-select>
            </el-form-item>
          <#elseif column.htmlType == "datetime" && column.queryType != "BETWEEN">
            <el-form-item label="${comment}" prop="${column.javaField}">
              <el-date-picker clearable
                      v-model="queryParams.${column.javaField}"
                      type="date"
                      value-format="YYYY-MM-DD"
                      placeholder="选择${comment}"
              />
            </el-form-item>
          <#elseif column.htmlType == "datetime" && column.queryType == "BETWEEN">
            <el-form-item label="${comment}" style="width: 308px">
              <el-date-picker
                v-model="dateRange${AttrName}"
                value-format="YYYY-MM-DD HH:mm:ss"
                type="daterange"
                range-separator="-"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                :default-time="[new Date(2000, 1, 1, 0, 0, 0), new Date(2000, 1, 1, 23, 59, 59)]"
              />
            </el-form-item>
          </#if>
        </#if>
      </#list>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
        </el-card>
      </div>
    </transition>

    <el-card shadow="never">
      <template #header>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" plain icon="Plus" @click="handleAdd()" v-has-perms="['${permissionPrefix}:add']">新增</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="info" plain icon="Sort" @click="handleToggleExpandAll">展开/折叠</el-button>
          </el-col>
          <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>
      </template>
      <el-table
        ref="${businessName}TableRef"
        v-loading="loading"
        :data="${businessName}List"
        row-key="${treeCode}"
        border
        :default-expand-all="isExpandAll"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
      >
        <#list columns as column>
          <#assign javaField = column.javaField>
          <#assign parentheseIndex = column.columnComment?index_of("（")>
          <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
          <#else>
            <#assign comment = column.columnComment>
          </#if>
          <#if !column.pk>
            <#if column.isList && column.htmlType == "datetime">
              <el-table-column label="${comment}" align="center" prop="${javaField}" width="180">
                <template #default="scope">
                  <span>{{ parseTime(scope.row.${javaField}, '{y}-{m}-{d}') }}</span>
                </template>
              </el-table-column>
            <#elseif column.isList && column.htmlType == "imageUpload">
              <el-table-column label="${comment}" align="center" prop="${javaField}Url" width="100">
                <template #default="scope">
                  <image-preview :src="scope.row.${javaField}Url" :width="50" :height="50"/>
                </template>
              </el-table-column>
            <#elseif column.isList && column.dictCode && "" != column.dictCode>
              <el-table-column label="${comment}" align="center" prop="${javaField}">
                <template #default="scope">
                  <#if column.htmlType == "checkbox">
                    <dict-tag :options="${column.dictCode}" :value="scope.row.${javaField} ? scope.row.${javaField}.split(',') : []"/>
                  <#else>
                    <dict-tag :options="${column.dictCode}" :value="scope.row.${javaField}"/>
                  </#if>
                </template>
              </el-table-column>
            <#elseif column.isList && "" != javaField>
              <#if column_index == 1>
                <el-table-column label="${comment}" prop="${javaField}" />
              <#else>
                <el-table-column label="${comment}" align="center" prop="${javaField}" />
              </#if>
            </#if>
          </#if>
        </#list>
        <el-table-column label="操作" fixed="right"  align="center" class-name="small-padding fixed-width">
          <template #default="scope">
            <el-tooltip content="修改" placement="top">
              <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-has-perms="['${permissionPrefix}:edit']" />
            </el-tooltip>
            <el-tooltip content="新增" placement="top">
              <el-button link type="primary" icon="Plus" @click="handleAdd(scope.row)" v-has-perms="['${permissionPrefix}:add']" />
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-has-perms="['${permissionPrefix}:remove']" />
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    <!-- 添加或修改${functionName}对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="500px" append-to-body>
      <el-form ref="${businessName}FormRef" :model="form" :rules="rules" label-width="80px">
        <#list columns as column>
          <#assign field = column.javaField>
          <#if (column.isInsert || column.isEdit) && !column.pk>
            <#assign parentheseIndex = column.columnComment?index_of("（")>
            <#if parentheseIndex != -1>
              <#assign comment = column.columnComment?substring(0, parentheseIndex)>
            <#else>
              <#assign comment = column.columnComment>
            </#if>
            <#assign dictCode = column.dictCode>
            <#if "" != treeParentCode && column.javaField == treeParentCode>
              <el-form-item label="${comment}" prop="${treeParentCode}">
                <el-tree-select
                  v-model="form.${treeParentCode}"
                  :data="${businessName}Options"
                  :props="{ value: '${treeCode}', label: '${treeName}', children: 'children' }"
                  value-key="${treeCode}"
                  placeholder="请选择${comment}"
                  check-strictly
                />
              </el-form-item>
            <#elseif column.htmlType == "input">
              <el-form-item label="${comment}" prop="${field}">
                <el-input v-model="form.${field}" placeholder="请输入${comment}" />
              </el-form-item>
            <#elseif column.htmlType == "imageUpload">
              <el-form-item label="${comment}" prop="${field}">
                <image-upload v-model="form.${field}"/>
              </el-form-item>
            <#elseif column.htmlType == "fileUpload">
              <el-form-item label="${comment}" prop="${field}">
                <file-upload v-model="form.${field}"/>
              </el-form-item>
            <#elseif column.htmlType == "editor">
              <el-form-item label="${comment}">
                <editor v-model="form.${field}" :min-height="192"/>
              </el-form-item>
            <#elseif column.htmlType == "select" && "" != dictCode>
              <el-form-item label="${comment}" prop="${field}">
                <el-select v-model="form.${field}" placeholder="请选择${comment}">
                  <el-option
                    v-for="dict in ${dictCode}"
                    :key="dict.value"
                    :label="dict.label"
                    <#if column.javaType == "Integer" || column.javaType == "Long">
                      :value="parseInt(dict.value)"
                    <#else>
                      :value="dict.value"
                    </#if>
                  ></el-option>
                </el-select>
              </el-form-item>
            <#elseif column.htmlType == "select" && dictCode>
              <el-form-item label="${comment}" prop="${field}">
                <el-select v-model="form.${field}" placeholder="请选择${comment}">
                  <el-option label="请选择字典生成" value="" />
                </el-select>
              </el-form-item>
            <#elseif column.htmlType == "checkbox" && "" != dictCode>
              <el-form-item label="${comment}" prop="${field}">
                <el-checkbox-group v-model="form.${field}">
                  <el-checkbox
                    v-for="dict in ${dictCode}"
                    :key="dict.value"
                    :label="dict.value">
                    {{dict.label}}
                  </el-checkbox>
                </el-checkbox-group>
              </el-form-item>
            <#elseif column.htmlType == "checkbox" && dictCode>
              <el-form-item label="${comment}" prop="${field}">
                <el-checkbox-group v-model="form.${field}">
                  <el-checkbox>请选择字典生成</el-checkbox>
                </el-checkbox-group>
              </el-form-item>
            <#elseif column.htmlType == "radio" && "" != dictCode>
              <el-form-item label="${comment}" prop="${field}">
                <el-radio-group v-model="form.${field}">
                  <el-radio
                    v-for="dict in ${dictCode}"
                    :key="dict.value"
                    <#if column.javaType == "Integer" || column.javaType == "Long">
                      :value="parseInt(dict.value)"
                    <#else>
                      :value="dict.value"
                    </#if>
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            <#elseif column.htmlType == "radio" && dictCode>
              <el-form-item label="${comment}" prop="${field}">
                <el-radio-group v-model="form.${field}">
                  <el-radio value="1">请选择字典生成</el-radio>
                </el-radio-group>
              </el-form-item>
            <#elseif column.htmlType == "datetime">
              <el-form-item label="${comment}" prop="${field}">
                <el-date-picker clearable
                        v-model="form.${field}"
                        type="datetime"
                        value-format="YYYY-MM-DD HH:mm:ss"
                        placeholder="选择${comment}"
                />
              </el-form-item>
            <#elseif column.htmlType == "textarea">
              <el-form-item label="${comment}" prop="${field}">
                <el-input v-model="form.${field}" type="textarea" placeholder="请输入内容" />
              </el-form-item>
            </#if>
          </#if>
        </#list>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button :loading="buttonLoading" type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="${className}" lang="ts">
  type ${className}Option = {
    ${treeCode}: number;
    ${treeName}: string;
    children?: ${className}Option[];
  }


  <#if dicts != ''>
  <#assign dictsNoSymbol = dicts?replace("'", "")>
  const { ${dictsNoSymbol} } = toRefs<any>(useDict(${dicts}));
  </#if>

  const ${businessName}List = ref<${className}VO[]>([]);
  const ${businessName}Options = ref<${className}Option[]>([]);
  const buttonLoading = ref(false);
  const showSearch = ref(true);
  const isExpandAll = ref(true);
  const loading = ref(false);

  const queryFormRef = ref<ElFormInstance>();
  const ${businessName}FormRef = ref<ElFormInstance>();
  const ${businessName}TableRef = ref<ElTableInstance>()

  const dialog = reactive<DialogOption>({
    visible: false,
    title: ''
  });

  <#list columns as column>
  <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
  <#assign AttrName = column.javaField?substring(0,1)?upper_case + column.javaField?substring(1)>
  const dateRange${AttrName} = ref<[DateModelType, DateModelType]>(['', '']);
  </#if>
  </#list>

  const initFormData: ${className}Form = {
    <#list columns as column>
    <#if column.isInsert || column.isEdit>
    <#if column.htmlType == "checkbox">
    ${column.javaField}: []<#if column_has_next>,</#if>
    <#else>
    ${column.javaField}: undefined<#if column_has_next>,</#if>
    </#if>
    </#if>
    </#list>
  }

  const data = reactive<PageData<${className}Form, ${className}Query>>({
    form: {...initFormData},
    queryParams: {
      <#list columns as column>
      <#if column.isQuery>
      <#if column.htmlType != "datetime" || column.queryType != "BETWEEN">
      ${column.javaField}: undefined,<#if column_has_next></#if>
      </#if>
      </#if>
      </#list>
      params: {
        <#list columns as column>
        <#if column.isQuery>
        <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
        ${column.javaField}: undefined<#if column_has_next>,</#if>
        </#if>
        </#if>
        </#list>
      }
    },
    rules: {
      <#list columns as column>
      <#if (column.isInsert || column.isEdit) && column.isRequired>
      <#assign parentheseIndex = column.columnComment?index_of("（")>
      <#if parentheseIndex != -1>
      <#assign comment = column.columnComment?substring(0, parentheseIndex)>
      <#else>
      <#assign comment = column.columnComment>
      </#if>
      ${column.javaField}: [
        { required: true, message: "${comment}不能为空", trigger: <#if column.htmlType == "select" || column.htmlType == "radio">"change"<#else>"blur"</#if> }
      ]<#if column_has_next>,</#if>
      </#if>
      </#list>
    }
  });

  const { queryParams, form, rules } = toRefs(data);

  /** 查询${functionName}列表 */
  const getList = async () => {
    loading.value = true;
    <#list columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
    queryParams.value.params = {};
    <#break>
    </#if>
    </#list>
    <#list columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
    <#assign AttrName = column.javaField?substring(0,1)?upper_case + column.javaField?substring(1)>
    addDateRange(queryParams.value, dateRange${AttrName}.value, '${AttrName}');
    </#if>
    </#list>
    const res = await list${className}(queryParams.value);
    const data = handleTree<${className}VO>(res.data, "${treeCode}", "${treeParentCode}");
    if (data) {
      ${businessName}List.value = data;
      loading.value = false;
    }
  }

  /** 查询${functionName}下拉树结构 */
  const getTreeSelect = async () => {
    const res = await list${className}();
    ${businessName}Options.value = [];
    const data: ${className}Option = { ${treeCode}: 0, ${treeName}: '顶级节点', children: [] };
    data.children = handleTree<${className}Option>(res.data, "${treeCode}", "${treeParentCode}");
    ${businessName}Options.value.push(data);
  }

  // 取消按钮
  const cancel = () => {
    reset();
    dialog.visible = false;
  }

  // 表单重置
  const reset = () => {
    form.value = {...initFormData}
    ${businessName}FormRef.value?.resetFields();
  }

  /** 搜索按钮操作 */
  const handleQuery = () => {
    getList();
  }

  /** 重置按钮操作 */
  const resetQuery = () => {
    <#list columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
    <#assign AttrName = column.javaField?substring(0,1)?upper_case + column.javaField?substring(1)>
    dateRange${AttrName}.value = ['', ''];
    </#if>
    </#list>
    queryFormRef.value?.resetFields();
    handleQuery();
  }

  /** 新增按钮操作 */
  const handleAdd = (row?: ${className}VO) => {
    reset();
    getTreeSelect();
    if (row != null && row.${treeCode}) {
      form.value.${treeParentCode} = row.${treeCode};
    } else {
      form.value.${treeParentCode} = 0;
    }
    dialog.visible = true;
    dialog.title = "添加${functionName}";
  }

  /** 展开/折叠操作 */
  const handleToggleExpandAll = () => {
    isExpandAll.value = !isExpandAll.value;
    toggleExpandAll(${businessName}List.value, isExpandAll.value)
  }

  /** 展开/折叠操作 */
  const toggleExpandAll = (data: ${className}VO[], status: boolean) => {
    data.forEach((item) => {
      ${businessName}TableRef.value?.toggleRowExpansion(item, status)
      if (item.children && item.children.length > 0) toggleExpandAll(item.children, status)
    })
  }

  /** 修改按钮操作 */
  const handleUpdate = async (row: ${className}VO) => {
    reset();
    await getTreeSelect();
    if (row != null) {
      form.value.${treeParentCode} = row.${treeParentCode};
    }
    const res = await get${className}(row.${pkColumn.javaField});
    Object.assign(form.value, res.data);
    <#list columns as column>
    <#if column.htmlType == "checkbox">
    form.value.${column.javaField} = form.value.${column.javaField}.split(",");
    </#if>
    </#list>
    dialog.visible = true;
    dialog.title = "修改${functionName}";
  }

  /** 提交按钮 */
  const submitForm = () => {
    ${businessName}FormRef.value?.validate(async (valid: boolean) => {
      if (valid) {
        buttonLoading.value = true;
        <#list columns as column>
        <#if column.htmlType == "checkbox">
        form.value.${column.javaField} = form.value.${column.javaField}.join(",");
        </#if>
        </#list>
        if (form.value.${pkColumn.javaField}) {
          await update${className}(form.value).finally(() => buttonLoading.value = false);
        } else {
          await add${className}(form.value).finally(() => buttonLoading.value = false);
        }
        modal.msgSuccess("操作成功");
    dialog.visible = false;
    getList();
  }
  });
}

/** 删除按钮操作 */
const handleDelete = async (row: ${className}VO) => {
  await modal.confirm('是否确认删除${functionName}编号为"' + row.${pkColumn.javaField} + '"的数据项？');
  loading.value = true;
  await del${className}(row.${pkColumn.javaField}).finally(() => loading.value = false);
  await getList();
  modal.msgSuccess("删除成功");
}

onMounted(() => {
  getList();
});
</script>
