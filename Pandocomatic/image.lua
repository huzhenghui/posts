local image_prefix
local root
local markdown_path
function extract_metadata_vars (meta)
    for k, v in pairs(meta) do
        if k == 'IMAGE_PREFIX' then
            image_prefix = pandoc.utils.stringify(v)
        end
        if k == 'pandocomatic-fileinfo' then
            for k1,v1 in pairs(v) do
                if k1 == 'src_path' then
                    root = pandoc.utils.stringify(v1)
                end
                if k1 == 'path' then
                    markdown_path = pandoc.utils.stringify(v1)
                end
            end
        end
    end
end
function image_converter(elem)
    if pandoc.path.is_relative(elem.src) then
        directory = pandoc.path.directory(markdown_path)
        image_absolute_path = pandoc.path.join({directory, elem.src})
        image_relative_root_path = pandoc.path.make_relative(image_absolute_path, root)
        image_url = image_prefix .. image_relative_root_path
        elem.src = image_url
    end
    return elem
end
return {
    {Meta = extract_metadata_vars},
    {Image = image_converter}
}