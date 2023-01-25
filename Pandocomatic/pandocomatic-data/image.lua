-- 图片地址前缀
local image_prefix
-- markdown 文件夹的根目录
local root
-- markdown_path 是正在转换的 markdown 文件的路径
local markdown_path
-- 从元数据中提取元数据变量
function extract_metadata_vars (meta)
    -- 枚举元数据中的变量
    for k, v in pairs(meta) do
        -- 从元数据中提取 IMAGE_PREFIX 变量
        if k == 'IMAGE_PREFIX' then
            -- pandoc.utils.stringify(v) 是一个将变量转换为字符串的函数
            image_prefix = pandoc.utils.stringify(v)
        end
        -- 获取 pandocomatic 设置的文件的信息
        if k == 'pandocomatic-fileinfo' then
            -- 获取 markdown 文件的路径和 markdown 文件的根目录。
            for k1,v1 in pairs(v) do
                -- src_path 是 markdown 文件的文件夹的根目录
                if k1 == 'src_path' then
                    -- root 是 markdown 文件的根目录
                    root = pandoc.utils.stringify(v1)
                end
                -- 获取 markdown 文件的路径
                if k1 == 'path' then
                    -- markdown_path 是 markdown 文件的路径
                    markdown_path = pandoc.utils.stringify(v1)
                end
            end
        end
    end
end
-- 将图像路径转换为 URL 的函数
function image_converter(elem)
    -- 检查图像是否已经是 URL。如果是，它什么也不做。如果不是，它将图像路径转换为 URL。
    if elem.src:find('https://', 1, true) ~= 1 then
        -- directory 是 markdown 文件的目录
        directory = pandoc.path.directory(markdown_path)
        -- pandoc.path.join 是连接两条路径的函数，结果为图像的绝对路径。
        image_absolute_path = pandoc.path.join({directory, elem.src})
        -- image_relative_root_path 是图片相对于 markdown 文件根目录的路径。
        image_relative_root_path = pandoc.path.make_relative(image_absolute_path, root)
        -- image_prefix 是 URL 的前缀，拼接图片相对路径得到image_url 是图片的 URL。
        image_url = image_prefix .. image_relative_root_path
        -- 更改 Image 元素的 src 属性的值为图片的 URL。
        elem.src = image_url
    end
    -- 返回修改后的元素。
    return elem
end
-- 返回函数钩子
return {
    -- {Meta = extract_metadata_vars} 是将应用于元数据的过滤器。
    {Meta = extract_metadata_vars},
    -- 将 image_converter 函数应用于所有 Image 元素。
    {Image = image_converter}
}