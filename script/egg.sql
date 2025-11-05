drop table gen_table;
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
drop table gen_column;
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
    is_visible     bit             not null default b'1' comment '是否可见',
    is_query       bit             not null default b'0' comment '作为查询条件',
    query_type     varchar(32)     not null default 'EQ' comment '查询方式',
    html_type      varchar(64)     not null default 'INPUT' comment 'Vue组件类型',
    column_option  json comment '列其他属性',
    sort           int             null     default 100 comment '排序',
    primary key (id),
    index idx_table_id (table_id)
) comment '代码生成列信息';
drop table test_table;
create table test_table
(
    id             bigint    not null auto_increment comment 'id',
    tiny_int_col   tinyint                                                   default null comment 'tiny_int列',
    small_int_col  smallint                                                  default null comment 'small_int列',
    medium_int_col mediumint                                                 default null comment 'medium_int列',
    int_col        int                                                       default null comment 'int列',
    big_int_col    bigint                                                    default null comment 'big_int列',
    float_col      float                                                     default null comment 'float列',
    double_col     double                                                    default null comment 'double列',
    decimal_col    decimal(10, 2)                                            default null comment 'decimal列',
    bit_col        bit(1)                                                    default null comment 'bit列',
    date_col       date                                                      default null comment 'date列',
    time_col       time                                                      default null comment 'time列',
    datetime_col   datetime                                                  default null comment 'datetime列',
    timestamp_col  timestamp null                                            default current_timestamp comment 'timestamp列',
    year_col       year                                                      default null comment 'year列',
    char_col       char(10)                                                  default null comment 'char列',
    varchar_col    varchar(255)                                              default null comment 'varchar列',
    binary_col     binary(10)                                                default null comment 'binary列',
    varbinary_col  varbinary(255)                                            default null comment 'varbinary列',
    tinytext_col   tinytext comment 'tinytext列',
    text_col       text comment 'text列',
    mediumtext_col mediumtext comment 'mediumtext列',
    longtext_col   longtext comment 'longtext列',
    enum_col       enum ('v1','v2','v3','v4','v5','v6','v7','v8','v9','v10') default null comment 'enum列',
    set_col        set ('v1','v2','v3','v4','v5','v6','v7','v8','v9','v10')  default null comment 'set列',
    blob_col       blob comment 'blob列',
    tinyblob_col   tinyblob comment 'tinyblob列',
    mediumblob_col mediumblob comment 'mediumblob列',
    longblob_col   longblob comment 'longblob列',
    primary key (id)
) comment '测试表';
insert into test_table (id, tiny_int_col, small_int_col, medium_int_col, int_col, big_int_col, float_col, double_col, decimal_col,
                        bit_col, date_col, time_col, datetime_col, timestamp_col, year_col, char_col, varchar_col, binary_col,
                        varbinary_col, tinytext_col, text_col, mediumtext_col, longtext_col, enum_col, set_col, blob_col,
                        tinyblob_col, mediumblob_col, longblob_col)
values (1, 1, 100, 1000, 10000, 100000, 123.45, 1234.5678, 999.99, _binary '', '2023-01-01', '12:30:45', '2023-01-01 12:30:45',
        '2025-09-21 13:17:42', 2023, 'abc', 'sample text', _binary 'binary1\0\0\0', _binary 'varbinary', 'tiny text', 'regular text', 'medium text',
        'very long text content', 'v1', 'v1', _binary 'blob', _binary 'tinyblob', _binary 'mediumblob', _binary 'longblob'),
       (2, 2, 200, 2000, 20000, 200000, 223.45, 2234.5678, 899.99, _binary '', '2023-01-02', '13:30:45', '2023-01-02 13:30:45',
        '2025-09-21 13:17:42', 2023, 'def', 'another sample', _binary 'binary2\0\0\0', _binary 'varbinary2', 'tiny text 2', 'regular text 2',
        'medium text 2', 'very long text content 2', 'v2', 'v2', _binary 'blob2', _binary 'tinyblob2', _binary 'mediumblob2',
        _binary 'longblob2'),
       (3, 3, 300, 3000, 30000, 300000, 323.45, 3234.5678, 799.99, _binary '', '2023-01-03', '14:30:45', '2023-01-03 14:30:45',
        '2025-09-21 13:17:42', 2023, 'ghi', 'third sample', _binary 'binary3\0\0\0', _binary 'varbinary3', 'tiny text 3', 'regular text 3',
        'medium text 3', 'very long text content 3', 'v3', 'v1,v2', null, null, null, null),
       (4, 4, 400, 4000, 40000, 400000, 423.45, 4234.5678, 699.99, _binary '', '2023-01-04', '15:30:45', '2023-01-04 15:30:45',
        '2025-09-21 13:17:42', 2023, 'jkl', 'fourth sample', _binary 'binary4\0\0\0', _binary 'varbinary4', 'tiny text 4', 'regular text 4',
        'medium text 4', 'very long text content 4', 'v1', 'v3', null, null, null, null),
       (5, 5, 500, 5000, 50000, 500000, 523.45, 5234.5678, 599.99, _binary '', '2023-01-05', '16:30:45', '2023-01-05 16:30:45',
        '2025-09-21 13:17:42', 2023, 'mno', 'fifth sample', _binary 'binary5\0\0\0', _binary 'varbinary5', 'tiny text 5', 'regular text 5',
        'medium text 5', 'very long text content 5', 'v2', 'v1,v3', null, null, null, null);
drop table test_tree;
create table test_tree
(
    id        bigint unsigned not null auto_increment comment '主键id',
    parent_id bigint unsigned not null default 0 comment '父id',
    name      varchar(100)    not null comment '名称',
    sort      int             not null default 100 comment '排序',
    level     int             not null default 1 comment '层级',
    primary key (id)
) comment '测试树表';
INSERT INTO test_tree (id, parent_id, name, sort, level)
VALUES (1, 0, 'L1-根节点', 100, 1),
-- 第二层（根节点的左右子节点）
       (2, 1, 'L2-根左子', 90, 2),
       (3, 1, 'L2-根右子', 110, 2),
-- 第三层（第二层节点的子节点）
       (4, 2, 'L3-左1左子', 90, 3),
       (5, 2, 'L3-左1右子', 110, 3),
       (6, 3, 'L3-右1左子', 90, 3),
       (7, 3, 'L3-右1右子', 110, 3),
-- 第四层（第三层节点的子节点）
       (8, 4, 'L4-左1左左', 90, 4),
       (9, 4, 'L4-左1左右', 110, 4),
       (10, 5, 'L4-左1右左', 90, 4),
       (11, 5, 'L4-左1右右', 110, 4),
       (12, 6, 'L4-右1左左', 90, 4),
       (13, 6, 'L4-右1左右', 110, 4),
       (14, 7, 'L4-右1右左', 90, 4),
       (15, 7, 'L4-右1右右', 110, 4);


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