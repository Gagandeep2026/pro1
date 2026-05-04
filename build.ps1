$images = Get-ChildItem "img/" -Filter "*.jpg" | Select-Object -ExpandProperty Name
$global:images = $images
$global:i = 0

Write-Host "Reading extracted HTML..."
$content = Get-Content "refrence\extracted\b7more-in.html" -Raw

Write-Host "Replacing Branding..."
$content = $content -replace 'B More India', 'Virendra Textrioum'
$content = $content -replace 'B More', 'Virendra Textrioum'
$content = $content -replace 'B>More', 'Virendra Textrioum'
$content = $content -replace 'B&gt;More', 'Virendra Textrioum'
$content = $content -replace 'BMORE', 'Virendra Textrioum'
$content = $content -replace 'B7more', 'Virendra'
$content = $content -replace 'b7more\.in', 'virendra.com'

Write-Host "Replacing Logos..."
# Try to catch any logo pngs first
$content = $content -replace '(?:http:|https:|)//[^"''\s]*?LOGO[^"''\s]*?\.png(?:[^"''\s;]*)?', 'logo/IMG_2014.PNG'
$content = $content -replace '(?:http:|https:|)//[^"''\s]*?Profile[^"''\s]*?\.png(?:[^"''\s;]*)?', 'logo/IMG_2014.PNG'
$content = $content -replace '(?:http:|https:|)//[^"''\s]*?Virendra_22ead718[^"''\s]*?\.png(?:[^"''\s;]*)?', 'logo/IMG_2014.PNG'

Write-Host "Replacing Shopify Images with local img collection..."
$re = [regex] '(?:http:|https:|)//[^"''\s]*?cdn/shop/files/[^"''\s]*?\.(?:jpg|png|jpeg|webp)(?:\?[^"''\s]*)?'
$content = $re.Replace($content, {
    param($match)
    $imgName = $global:images[$global:i % $global:images.Count]
    $global:i++
    return "img/$imgName"
})

Write-Host "Writing to index.html..."
Set-Content -Path "index.html" -Value $content
Write-Host "Build Complete!"
