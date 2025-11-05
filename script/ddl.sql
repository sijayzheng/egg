create table gen_table
(
    id              bigint unsigned not null auto_increment comment '主键id',
    table_name      varchar(100)    not null comment '物理表名',
    table_comment   varchar(500)    not null default '' comment '表注释',
    package_name    varchar(100)    not null comment 'Java包路径',
    module_name     varchar(50)     not null comment '模块名',
    class_name      varchar(200)    not null comment '实体类名',
    class_comment   varchar(200)    not null default '' comment '实体类注释',
    business_name   varchar(200)    not null comment '业务名',
    author          varchar(50)     not null comment '作者',
    generate_type   varchar(10)     not null comment '生成类型',
    tree_key        varchar(50)     not null default '' comment '唯一标识字段',
    tree_parent_key varchar(50)     not null default '' comment '父标识字段',
    tree_label      varchar(50)     not null default '' comment '展示字段',
    parent_menu_id  bigint          not null default 1 comment '所属菜单',
    primary key (id),
    unique key (table_name)
) comment '代码生成表信息';
create table gen_column
(
    id             bigint unsigned not null auto_increment comment '主键id',
    table_id       bigint unsigned not null comment '表信息id',
    column_name    varchar(128)    not null default '' comment '物理名',
    column_comment varchar(512)    not null default '' comment '注释',
    column_type    varchar(128)    not null default '' comment '数据类型',
    java_type      varchar(64)     not null default '' comment 'Java类型',
    java_field     varchar(128)    not null default '' comment 'Java字段名',
    java_comment   varchar(128)    not null default '' comment 'Java字段注释',
    java_desc      varchar(512)    not null default '' comment 'Java字段描述',
    column_key     varchar(4)      not null default '' comment '约束类型',
    is_required    bit             not null default b'0' comment '是否必填',
    is_insert      bit             not null default b'1' comment '插入时包含',
    is_edit        bit             not null default b'1' comment '编辑时包含',
    is_list        bit             not null default b'1' comment '列表显示',
    is_query       bit             not null default b'0' comment '作为查询条件',
    query_type     varchar(32)     not null default 'EQ' comment '查询方式',
    html_type      varchar(64)     not null default 'INPUT' comment 'Vue组件类型',
    column_option  json comment '列其他属性',
    sort           int             null     default 100 comment '排序',
    primary key (id),
    index idx_table_id (table_id)
) comment '代码生成列信息';
create table sys_dept
(
    dept_id       bigint not null comment '部门id',
    parent_id     bigint          default 0 comment '父部门id',
    ancestors     varchar(1000)   default '' comment '祖级列表',
    dept_name     varchar(30)     default '' comment '部门名称',
    dept_category bigint          default 0 comment '部门类别',
    sort          int             default 0 comment '显示顺序',
    leader        bigint          default 0 comment '负责人',
    phone         varchar(11)     default '' comment '联系电话',
    email         varchar(50)     default '' comment '邮箱',
    is_enabled    bit    not null default b'0' comment '启用',
    is_deleted    bit    not null default b'0' comment '删除',
    create_dept   bigint          default 0 comment '创建部门',
    create_by     bigint          default 0 comment '创建者',
    create_time   datetime        default current_timestamp comment '创建时间',
    update_by     bigint          default 0 comment '更新者',
    update_time   datetime        default current_timestamp comment '更新时间',
    primary key (dept_id)
) comment '部门表';
create table sys_post
(
    post_id       bigint      not null comment '岗位id',
    dept_id       bigint      not null comment '部门id',
    post_code     varchar(64) not null comment '岗位编码',
    post_category varchar(100)         default '' comment '岗位类别编码',
    post_name     varchar(50) not null comment '岗位名称',
    sort          int         not null comment '显示顺序',
    is_enabled    bit         not null default b'0' comment '启用',
    is_deleted    bit         not null default b'0' comment '删除',
    create_dept   bigint               default 0 comment '创建部门',
    create_by     bigint               default 0 comment '创建者',
    create_time   datetime             default current_timestamp comment '创建时间',
    update_by     bigint               default 0 comment '更新者',
    update_time   datetime             default current_timestamp comment '更新时间',
    remark        varchar(500)         default '' comment '备注',
    primary key (post_id)
) comment '岗位表';
create table sys_role
(
    role_id                bigint       not null comment '角色id',
    role_name              varchar(30)  not null comment '角色名称',
    role_code              varchar(100) not null comment '角色权限字符串',
    sort                   int          not null comment '显示顺序',
    data_scope             char(1)               default '1' comment '数据范围',
    is_menu_check_strictly bit          not null default b'1' comment '菜单树选择项关联显示',
    is_dept_check_strictly bit          not null default b'1' comment '部门树选择项关联显示',
    is_enabled             bit          not null default b'0' comment '启用',
    is_deleted             bit          not null default b'0' comment '删除',
    create_dept            bigint                default 0 comment '创建部门',
    create_by              bigint                default 0 comment '创建者',
    create_time            datetime              default current_timestamp comment '创建时间',
    update_by              bigint                default 0 comment '更新者',
    update_time            datetime              default current_timestamp comment '更新时间',
    remark                 varchar(500)          default '' comment '备注',
    primary key (role_id)
) comment '角色表';
create table sys_menu
(
    menu_id     bigint      not null comment '菜单id',
    menu_name   varchar(50) not null comment '菜单名称',
    parent_id   bigint               default 0 comment '父菜单id',
    sort        int                  default 0 comment '显示顺序',
    path        varchar(200)         default '' comment '路由地址',
    component   varchar(255)         default '' comment '组件路径',
    query_param varchar(255)         default '' comment '路由参数',
    is_frame    bit         not null default b'0' comment '是否为外链',
    is_cache    bit         not null default b'1' comment '是否缓存',
    menu_type   char(1)              default 'D' comment '菜单类型',
    is_visible  bit         not null default b'1' comment '显示',
    is_enabled  bit         not null default b'0' comment '启用',
    perms       varchar(100)         default '' comment '权限标识',
    icon        varchar(100)         default '#' comment '菜单图标',
    create_dept bigint               default 0 comment '创建部门',
    create_by   bigint               default 0 comment '创建者',
    create_time datetime             default current_timestamp comment '创建时间',
    update_by   bigint               default 0 comment '更新者',
    update_time datetime             default current_timestamp comment '更新时间',
    remark      varchar(500)         default '' comment '备注',
    primary key (menu_id)
) comment '菜单表';
create table sys_user
(
    user_id     bigint       not null comment '用户id',
    dept_id     bigint                default 0 comment '部门id',
    username    varchar(30)  not null comment '用户账号',
    avatar      bigint                default 0 comment '头像地址',
    password    varchar(100) not null default '' comment '密码',
    is_enabled  bit          not null default b'1' comment '启用',
    is_deleted  bit          not null default b'0' comment '删除',
    login_ip    varchar(128)          default '' comment '最后登录ip',
    login_date  datetime              default null comment '最后登录时间',
    create_dept bigint                default 0 comment '创建部门',
    create_by   bigint                default 0 comment '创建者',
    create_time datetime              default current_timestamp comment '创建时间',
    update_by   bigint                default 0 comment '更新者',
    update_time datetime              default current_timestamp comment '更新时间',
    primary key (user_id),
    unique key uk_username (username)
) comment '用户表';
create table sys_module
(
    module_id          bigint       not null comment '模块id',
    module_code        varchar(50)  not null comment '模块编码',
    module_name        varchar(100) not null comment '模块名称',
    module_description varchar(255)          default '' comment '模块描述',
    base_path          varchar(255)          default '' comment '基础路径',
    icon               varchar(100)          default '' comment '图标',
    sort               int                   default 0 comment '排序',
    is_enabled         bit          not null default b'0' comment '启用',
    create_dept        bigint                default 0 comment '创建部门',
    create_by          bigint                default 0 comment '创建者',
    create_time        datetime              default current_timestamp comment '创建时间',
    update_by          bigint                default 0 comment '更新者',
    update_time        datetime              default current_timestamp comment '更新时间',
    primary key (module_id),
    unique key uk_module_code (module_code)
) comment '模块表';
create table sys_user_role
(
    user_id bigint not null comment '用户id',
    role_id bigint not null comment '角色id',
    primary key (user_id, role_id)
) comment '用户角色关联表';
create table sys_role_menu
(
    role_id bigint not null comment '角色id',
    menu_id bigint not null comment '菜单id',
    primary key (role_id, menu_id)
) comment '角色菜单关联表';
create table sys_role_dept
(
    role_id bigint not null comment '角色id',
    dept_id bigint not null comment '部门id',
    primary key (role_id, dept_id)
) comment '角色部门关联表';
create table sys_user_post
(
    user_id bigint not null comment '用户id',
    post_id bigint not null comment '岗位id',
    primary key (user_id, post_id)
) comment '用户岗位关联表';
create table sys_user_module
(
    user_id   bigint not null,
    module_id bigint not null,
    primary key (user_id, module_id)
) comment '用户模块关联表';
create table sys_module_menu
(
    module_id bigint not null,
    menu_id   bigint not null,
    primary key (module_id, menu_id)
) comment '模块菜单关联表';
create table sys_dict_type
(
    dict_id     bigint not null comment '字典主键',
    dict_name   varchar(100) default '' comment '字典名称',
    dict_code   varchar(100) default '' comment '字典编码',
    create_dept bigint       default 0 comment '创建部门',
    create_by   bigint       default 0 comment '创建者',
    create_time datetime     default current_timestamp comment '创建时间',
    update_by   bigint       default 0 comment '更新者',
    update_time datetime     default current_timestamp comment '更新时间',
    remark      varchar(500) default '' comment '备注',
    primary key (dict_id),
    unique key uk_dict_code (dict_code)
) comment '字典类型表';
create table sys_dict_data
(
    dict_data_id bigint       not null comment '字典数据id',
    dict_type_id bigint       not null comment '字典类型id',
    dict_code    varchar(100) not null default '' comment '字典编码',
    dict_label   varchar(100)          default '' comment '字典标签',
    dict_value   varchar(100)          default '' comment '字典键值',
    sort         int                   default 0 comment '字典排序',
    css_class    varchar(100)          default '' comment '样式属性（其他样式扩展）',
    list_class   varchar(100)          default '' comment '表格回显样式',
    is_default   bit          not null default b'0' comment '是否默认',
    create_dept  bigint                default 0 comment '创建部门',
    create_by    bigint                default 0 comment '创建者',
    create_time  datetime              default current_timestamp comment '创建时间',
    update_by    bigint                default 0 comment '更新者',
    update_time  datetime              default current_timestamp comment '更新时间',
    remark       varchar(500)          default '' comment '备注',
    primary key (dict_data_id)
) comment '字典数据表';
create table sys_config
(
    config_id    bigint not null comment '参数主键',
    config_name  varchar(100)    default '' comment '参数名称',
    config_key   varchar(100)    default '' comment '参数键名',
    config_value varchar(500)    default '' comment '参数键值',
    config_type  bit    not null default b'0' comment '系统内置',
    create_dept  bigint          default 0 comment '创建部门',
    create_by    bigint          default 0 comment '创建者',
    create_time  datetime        default current_timestamp comment '创建时间',
    update_by    bigint          default 0 comment '更新者',
    update_time  datetime        default current_timestamp comment '更新时间',
    remark       varchar(500)    default '' comment '备注',
    primary key (config_id)
) comment '参数配置表';
create table sys_notice
(
    notice_id      bigint      not null comment '公告id',
    notice_title   varchar(50) not null comment '公告标题',
    notice_type    char(1)     not null comment '公告类型（1通知 2公告）',
    notice_content blob comment '公告内容',
    is_closed      bit         not null default b'0' comment '是否关闭',
    create_dept    bigint               default 0 comment '创建部门',
    create_by      bigint               default 0 comment '创建者',
    create_time    datetime             default current_timestamp comment '创建时间',
    update_by      bigint               default 0 comment '更新者',
    update_time    datetime             default current_timestamp comment '更新时间',
    remark         varchar(255)         default '' comment '备注',
    primary key (notice_id)
) comment '通知公告表';
create table sys_message
(
    message_id      bigint      not null comment '消息id',
    message_title   varchar(50) not null comment '消息标题',
    message_content text comment '消息内容',
    sender          bigint      not null default 1 comment '发送者',
    recipient       bigint      not null default 1 comment '接收者',
    is_read         bit         not null default b'0' comment '已读',
    create_dept     bigint               default 0 comment '创建部门',
    create_by       bigint               default 0 comment '创建者',
    create_time     datetime             default current_timestamp comment '创建时间',
    update_by       bigint               default 0 comment '更新者',
    update_time     datetime             default current_timestamp comment '更新时间',
    remark          varchar(255)         default '' comment '备注',
    primary key (message_id)
) comment '消息表';
create table file_storge
(
    file_id       bigint       not null comment '对象存储主键',
    file_name     varchar(255) not null default '' comment '文件名',
    original_name varchar(255) not null default '' comment '原名',
    file_suffix   varchar(10)  not null default '' comment '文件后缀名',
    path          varchar(500) not null comment '存储路径',
    create_dept   bigint                default 0 comment '创建部门',
    create_time   datetime              default current_timestamp comment '创建时间',
    create_by     bigint                default 0 comment '上传人',
    update_time   datetime              default current_timestamp comment '更新时间',
    update_by     bigint                default 0 comment '更新人',
    primary key (file_id)
) comment 'oss对象存储表';
create table file_oss_storge
(
    oss_id        bigint       not null comment '对象存储主键',
    file_name     varchar(255) not null default '' comment '文件名',
    original_name varchar(255) not null default '' comment '原名',
    file_suffix   varchar(10)  not null default '' comment '文件后缀名',
    url           varchar(500) not null comment 'url地址',
    service       varchar(20)  not null default 'minio' comment '服务商',
    create_dept   bigint                default 0 comment '创建部门',
    create_time   datetime              default current_timestamp comment '创建时间',
    create_by     bigint                default 0 comment '上传人',
    update_time   datetime              default current_timestamp comment '更新时间',
    update_by     bigint                default 0 comment '更新人',
    primary key (oss_id)
) comment 'oss对象存储表';
create table log_access
(
    access_id       bigint not null comment '日志主键',
    title           varchar(50)   default '' comment '模块标题',
    business_type   int           default 0 comment '业务类型（0其它 1新增 2修改 3删除）',
    method          varchar(100)  default '' comment '方法名称',
    request_method  varchar(10)   default '' comment '请求方式',
    access_username varchar(50)   default '' comment '访问人员',
    access_url      varchar(255)  default '' comment '请求url',
    access_ip       varchar(128)  default '' comment '主机地址',
    access_location varchar(255)  default '' comment '访问地点',
    access_param    varchar(4000) default '' comment '请求参数',
    json_result     varchar(4000) default '' comment '返回参数',
    status          int           default 200 comment '访问状态',
    error_msg       varchar(4000) default '' comment '错误消息',
    access_time     datetime      default current_timestamp comment '访问时间',
    cost_time       bigint        default 0 comment '消耗时间',
    primary key (access_id),
    index idx_log_access_business_type (business_type),
    index idx_log_access_status (status),
    index idx_log_access_access_time (access_time)
) comment '访问日志表';
create table log_login
(
    info_id        bigint not null comment '登录记录id',
    username       varchar(50)     default '' comment '用户账号',
    ipaddr         varchar(128)    default '' comment '登录ip地址',
    login_location varchar(255)    default '' comment '登录地点',
    browser        varchar(50)     default '' comment '浏览器类型',
    os             varchar(50)     default '' comment '操作系统',
    login_success  bit    not null default b'0' comment '登录状态',
    msg            varchar(255)    default '' comment '提示消息',
    login_time     datetime        default current_timestamp comment '登录时间',
    primary key (info_id),
    index idx_log_login_login_success (login_success),
    index idx_log_login_login_time (login_time)
) comment '登录日志表';
