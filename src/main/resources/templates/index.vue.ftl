<template>
  <div class="p-2">
    <transition>
      <div v-show="showSearch" class="mb-[6px]">
        <el-card shadow="hover">
          <el-form ref="queryFormRef" :inline="true" :model="queryParams">
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
        <#if column.queryType=="BETWEEN">
          <#if column.htmlType == "datePick">
            <el-form-item label="${comment}" prop="${column.javaField}" style="width: 300px">
              <el-date-picker v-model="dateRange${AttrName}" value-format="YYYY-MM-DD" type="daterange"
                      start-placeholder="开始日期" end-placeholder="结束日期" unlink-panels/>
            </el-form-item>
          <#elseif column.htmlType == "timePick">
            <el-form-item label="${comment}" prop="${column.javaField}" style="width: 300px">
              <el-time-picker v-model="dateRange${AttrName}" is-range start-placeholder="开始时间"
                      end-placeholder="结束时间"/>
            </el-form-item>
          <#elseif column.htmlType == "dateTimePick">
            <el-form-item label="${comment}" prop="${column.javaField}" style="width: 300px">
              <el-date-picker v-model="dateRange${AttrName}" value-format="YYYY-MM-DD HH:mm:ss" type="datetimerange"
                      start-placeholder="开始时间" end-placeholder="结束时间" unlink-panels/>
            </el-form-item>
          </#if>
        <#else>
          <#if column.htmlType == "input" || column.htmlType == "textarea">
            <el-form-item label="${comment}" prop="${column.javaField}">
              <el-input v-model="queryParams.${column.javaField}" clearable placeholder="请输入${comment}"/>
            </el-form-item>
          <#elseif column.htmlType == "select">
            <#if dictCode?has_content>
              <el-form-item label="${comment}" prop="${column.javaField}">
                <el-select v-model="queryParams.${column.javaField}" clearable placeholder="请选择${comment}">
                  <el-option v-for="dict in ${dictCode}" :key="dict.value" :label="dict.label" :value="dict.value"/>
                </el-select>
              </el-form-item>
            <#else>
              <el-form-item label="${comment}" prop="${column.javaField}">
                <el-select v-model="queryParams.${column.javaField}" clearable placeholder="请选择${comment}">
                  <el-option label="请选择字典生成" value=""/>
                </el-select>
              </el-form-item>
            </#if>
          <#elseif column.htmlType == "numberInput">
            <el-form-item label="${comment}" prop="${column.javaField}">
              <el-input-number controls-position="right" v-model="queryParams.${column.javaField}"/>
            </el-form-item>
          <#elseif column.htmlType == "radio">
            <#if dictCode?has_content>
              <el-form-item label="${comment}" prop="${column.javaField}">
                <el-radio-group v-model="queryParams.${column.javaField}">
                  <el-radio v-for="dict in ${dictCode}" :key="dict.value" :label="dict.label" :value="dict.value"/>
                </el-radio-group>
              </el-form-item>
            <#else>
              <el-form-item label="${comment}" prop="${column.javaField}">
                <el-radio-group v-model="queryParams.${column.javaField}">
                  <el-radio value="">请选择字典生成</el-radio>
                </el-radio-group>
              </el-form-item>
            </#if>
          </#if>
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
            <el-button type="primary" plain icon="Plus" @click="handleAdd" v-has-perms="['${permissionPrefix}:add']">新增</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button icon="Download" plain @click="importTemplate()">下载模板</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button v-has-perms="['${permissionPrefix}:import']" icon="Top" plain @click="handleImport()">导入</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button v-has-perms="['${permissionPrefix}:export']" icon="Download" plain @click="handleExport()">导出</el-button>
          </el-col>
          <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>
      </template>

      <el-table v-loading="loading" border :data="${businessName}List">
        <#list columns as column>
          <#assign javaField = column.javaField>
          <#assign parentheseIndex = column.columnComment?index_of("（")>
          <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
          <#else>
            <#assign comment = column.columnComment>
          </#if>
          <#if column.isPk>
            <el-table-column label="${comment}" align="center" prop="${javaField}"/>
          <#elseif column.isList && column.htmlType == "datetime">
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
          <#elseif column.isList && dictCode?has_content>
            <el-table-column label="${comment}" align="center" prop="${javaField}">
              <template #default="scope">
                <#if column.htmlType == "checkbox">
                  <dict-tag :options="${column.dictCode}" :value="scope.row.${javaField} ? scope.row.${javaField}.split(',') : []"/>
                <#else>
                  <dict-tag :options="${column.dictCode}" :value="scope.row.${javaField}"/>
                </#if>
              </template>
            </el-table-column>
          <#elseif column.isList && javaField?has_content>
            <el-table-column label="${comment}" align="center" prop="${javaField}"/>
          </#if>
        </#list>
        <el-table-column align="center" class-name="small-padding fixed-width" fixed="right" label="操作">
          <template #default="scope">
            <el-tooltip content="修改" placement="top">
              <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-has-perms="['${permissionPrefix}:edit']"/>
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-has-perms="['${permissionPrefix}:remove']"/>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize"
            @pagination="getList"/>
    </el-card>
    <!-- 添加或修改${functionName}对话框 -->
    <el-dialog :title="dialog.title" v-model="dialog.visible" width="500px" append-to-body>
      <el-form ref="${businessName}FormRef" :model="form" :rules="rules" label-width="80px">
        <#list columns as column>
          <#assign field = column.javaField>
          <#if (column.isInsert || column.isEdit) && !column.isPk>
          <#assign parentheseIndex = column.columnComment?index_of("（")>
          <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
          <#else>
            <#assign comment = column.columnComment>
          </#if>
          <#assign dictCode = column.dictCode>
          <#if column.htmlType == "input">
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
          <#elseif column.htmlType == "select">
              <#if dictCode?has_content>
          <el-form-item label="${comment}" prop="${field}">
            <el-select v-model="form.${field}" placeholder="请选择${comment}" clearable >
              <el-option v-for="dict in ${dictCode}" :key="dict.value" :label="dict.label" :value="dict.value"/>
            </el-select>
          </el-form-item>
              <#else>
          <el-form-item label="${comment}" prop="${field}">
            <el-select v-model="form.${field}" placeholder="请选择${comment}" clearable >
              <el-option label="请选择字典生成" value="" />
            </el-select>
          </el-form-item>
              </#if>
          <#elseif column.htmlType == "numberInput">
          <el-form-item label="${comment}" prop="${field}">
            <el-input-number controls-position="right" v-model="form.${field}"/>
          </el-form-item>
          <#elseif column.htmlType == "radio">
                <#if dictCode?has_content>
          <el-form-item label="${comment}" prop="${field}">
            <el-radio-group v-model="form.${field}">
              <el-radio v-for="dict in ${dictCode}" :key="dict.value" :label="dict.label" :value="dict.value"/>
            </el-radio-group>
          </el-form-item>
                <#else>
          <el-form-item label="${comment}" prop="${field}">
            <el-radio-group v-model="form.${field}">
              <el-radio value="">请选择字典生成</el-radio>
            </el-radio-group>
          </el-form-item>
                </#if>
          <#elseif column.htmlType == "datePick">
          <el-form-item label="${comment}" prop="${field}" style="width: 308px">
            <el-date-picker v-model="form.${field}" value-format="YYYY-MM-DD" type="date" start-placeholder="开始日期" end-placeholder="结束日期" unlink-panels/>
          </el-form-item>
          <#elseif column.htmlType == "timePick">
          <el-form-item label="${comment}" prop="${field}" style="width: 308px">
            <el-time-picker v-model="form.${field}" start-placeholder="开始时间" end-placeholder="结束时间"/>
          </el-form-item>
          <#elseif column.htmlType == "dateTimePick">
          <el-form-item label="${comment}" prop="${field}" style="width: 308px">
            <el-date-picker v-model="form.${field}" value-format="YYYY-MM-DD HH:mm:ss" type="datetime" start-placeholder="开始时间" end-placeholder="结束时间" unlink-panels/>
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
    <!-- 用户导入对话框 -->
    <el-dialog v-model="upload.open" :title="upload.title" append-to-body width="400px">
      <el-upload
        ref="uploadRef"
        :action="upload.url + '?updateSupport=' + upload.updateSupport"
        :auto-upload="false"
        :disabled="upload.isUploading"
        :headers="upload.headers"
        :limit="1"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        accept=".xlsx, .xls"
        drag>
        <el-icon class="el-icon--upload">
            <i-ep-upload-filled/>
        </el-icon>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <template #tip>
          <div class="text-center el-upload__tip">
            <div class="el-upload__tip">
              <el-checkbox v-model="upload.updateSupport"/>
              是否更新已经存在的数据
              </div>
              <span>仅允许导入xls、xlsx格式文件。</span>
              <el-link :underline="false" style="font-size: 12px; vertical-align: baseline" type="primary" @click="importTemplate">下载模板</el-link>
          </div>
        </template>
      </el-upload>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary"  :loading="upload.isUploading" @click="submitFileForm">确 定</el-button>
          <el-button @click="upload.open = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
<#if dicts != ''>
<#assign dictsNoSymbol = dicts?replace("'", "")>
const {${dictsNoSymbol}} = toRefs<any>(useDict(${dicts}))
</#if>
const ${businessName}List = ref<${className}VO[]>([])
const buttonLoading = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const total = ref(0)
<#list columns as column>
<#if (column.htmlType == "datePick"|| column.htmlType == "timePick" || column.htmlType == "dateTimePick") && column.queryType == "BETWEEN">
<#assign AttrName = column.javaField?substring(0,1)?upper_case + column.javaField?substring(1)>
const dateRange${AttrName} = ref<[DateModelType, DateModelType]>(['', ''])
</#if>
</#list>
const queryFormRef = ref<ElFormInstance>()
const ${businessName}FormRef = ref<ElFormInstance>()
const uploadRef = ref<ElUploadInstance>()
const dialog = reactive<DialogOption>({
  visible: false,
  title: ''
})
const upload = reactive<ImportOption>({
  open: false,
  title: '',
  isUploading: false,
  updateSupport: 0,
  headers: globalHeaders(),
  url: '/api/${moduleName}/${businessName}/importData'
})
const initFormData: ${className}Form = {
  <#list columns as column>
  <#if column.isInsert || column.isEdit>
  <#if column.htmlType == "checkbox">
  ${column.javaField}: []<#if column_has_next>, </#if>
  <#else>
  ${column.javaField}: undefined<#if column_has_next>, </#if>
  </#if>
  </#if>
  </#list>
}
const queryParams = ref<${className}Query>({
  pageNum: 1,
  pageSize: 10,
  <#list columns as column>
  <#if column.isQuery>
  <#if column.htmlType != "datetime" || column.queryType != "BETWEEN">
  ${column.javaField}: undefined, <#if column_has_next></#if>
  </#if>
  </#if>
  </#list>
  params: {
    <#list columns as column>
    <#if column.isQuery>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
    ${column.javaField}: undefined<#if column_has_next>, </#if>
    </#if>
    </#if>
    </#list>
  }
})
const form = ref<${className}Form>({...initFormData})
const rules = ref<ElFormRules>({
  <#list columns as column>
  <#if (column.isInsert || column.isEdit) && column.isRequired>
  <#assign parentheseIndex = column.columnComment?index_of("（")>
  <#if parentheseIndex != -1>
  <#assign comment = column.columnComment?substring(0, parentheseIndex)>
  <#else>
  <#assign comment = column.columnComment>
  </#if>
  ${column.javaField}: [
    {
      required: true,
      message: '${comment}不能为空',
      trigger: <#if column.htmlType == "select" || column.htmlType == "radio">'change'
      <#else>'blur'</#if>
    }
  ]<#if column_has_next>, </#if>
  </#if>
  </#list>
})
/** 查询${functionName}列表 */
const getList = async () => {
  loading.value = true
  <#list columns as column>
  <#if (column.htmlType == "datePick"|| column.htmlType == "timePick" || column.htmlType == "dateTimePick") && column.queryType == "BETWEEN">
  queryParams.value.params = {}
  <#break>
  </#if>
  </#list>
  <#list columns as column>
  <#if (column.htmlType == "datePick"|| column.htmlType == "timePick" || column.htmlType == "dateTimePick") && column.queryType == "BETWEEN">
  <#assign AttrName = column.javaField?substring(0,1)?upper_case + column.javaField?substring(1)>
  addDateRange(queryParams.value, dateRange${AttrName}.value, '${AttrName}')
  </#if>
  </#list>
  const res = await ${businessName}Api.list${className}(queryParams.value)
  ${businessName}List.value = res.rows
  total.value = res.total
  loading.value = false
}
/** 取消按钮 */
const cancel = () => {
  reset()
  dialog.visible = false
}
/** 表单重置 */
const reset = () => {
  form.value = {...initFormData}
  ${businessName}FormRef.value?.resetFields()
}
/** 搜索按钮操作 */
const handleQuery = () => {
  queryParams.value.pageNum = 1
  getList()
}
/** 重置按钮操作 */
const resetQuery = () => {
  <#list columns as column>
  <#if (column.htmlType == "datePick"|| column.htmlType == "timePick" || column.htmlType == "dateTimePick") && column.queryType == "BETWEEN">
  <#assign AttrName = column.javaField?substring(0,1)?upper_case + column.javaField?substring(1)>
  dateRange${AttrName}.value = ['', '']
  </#if>
  </#list>
  queryFormRef.value?.resetFields()
  handleQuery()
}
/** 新增按钮操作 */
const handleAdd = () => {
  reset()
  dialog.visible = true
  dialog.title = "添加${functionName}"
}
/** 修改按钮操作 */
const handleUpdate = async (row : ${className}VO ) => {
  reset()
  const _${pkColumn.javaField} = row?.${pkColumn.javaField}
  const res = await ${businessName}Api.get${className}(_${pkColumn.javaField})
  Object.assign(form.value, res.data)
  <#list columns as column>
  <#if column.htmlType == "checkbox">
  form.value.${column.javaField} = form.value.${column.javaField}.split(',')
  </#if>
  </#list>
  dialog.visible = true
  dialog.title = "修改${functionName}"
}
/** 提交按钮 */
const submitForm = () => {
  ${businessName}FormRef.value?.validate(async (valid: boolean) => {
    if (valid) {
      buttonLoading.value = true
      <#list columns as column>
      <#if column.htmlType == "checkbox">
      form.value.${column.javaField} = form.value.${column.javaField}.join(',')
      </#if>
      </#list>
      if (form.value.${pkColumn.javaField}) {
        await ${businessName}Api.update${className}(form.value).finally(() => buttonLoading.value = false)
      } else {
        await ${businessName}Api.add${className}(form.value).finally(() => buttonLoading.value = false)
      }
      ElMessage.success('操作成功')
      dialog.visible = false
      await getList()
    }
  })
}
/** 删除按钮操作 */
const handleDelete = async (row : ${className}VO ) => {
  const _${pkColumn.javaField}s = row?.${pkColumn.javaField}
  await modal.confirm('是否确认删除${functionName}编号为"' + _${pkColumn.javaField}s + '"的数据项？').finally(() => loading.value = false)
  await ${businessName}Api.del${className}(_${pkColumn.javaField}s)
  ElMessage.success('删除成功')
  await getList()
}
/** 导出按钮操作 */
const handleExport = () => {
  generalDownload('${moduleName}/${businessName}/export', {
    ...queryParams.value
  }, `${functionName}_${"${"}getTimestamp()${"}"}.xlsx`)
}
/** 下载模板操作 */
const importTemplate = () => {
  generalDownload('${moduleName}/${businessName}/importTemplate', {}, `${functionName}模板_${"${"}getTimestamp()${"}"}.xlsx`)
}
/** 导入按钮操作 */
const handleImport = () => {
  upload.title = '${functionName}导入'
  upload.open = true
}
/**文件上传中处理 */
const handleFileUploadProgress = () => {
  upload.isUploading = true
}
/** 文件上传成功处理 */
const handleFileSuccess = (response: any, file: UploadFile) => {
  upload.open = false
  upload.isUploading = false
  uploadRef.value?.handleRemove(file)
  ElMessage.info(response.msg)
  getList()
}

/** 提交上传文件 */
function submitFileForm() {
  uploadRef.value?.submit()
}

onMounted(() => {
  getList()
})
</script>
