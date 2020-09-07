#!/bin/sh

# 版本号
app_name="gen"
# 构建目录
dist_dir="dist"
# 输出目录
target_dir="$dist_dir/$app_name"

echo "开始构建..."

cd front

sh build.sh

cd ..


mvn clean package

echo "复制文件到$target_dir"

rm -rf $dist_dir
mkdir -p $target_dir

cp -r gen/target/*.jar $target_dir/gen.jar
cp -r script/* $target_dir
cp -r db/gen.db $target_dir/gen.db

echo "打成zip包"

cd $dist_dir
zip -r -q "$app_name.zip" $app_name

echo "构建完毕"