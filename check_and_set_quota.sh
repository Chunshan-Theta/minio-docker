# MinIO alias
MINIO_ALIAS="myminio"

#mc alias set localMinio http://localhost:9000 minio wulab35415
mc alias set $MINIO_ALIAS $MINIO_URL $ACCESS_KEY $SECRET_KEY

#!/bin/bash



# 列出所有 buckets
buckets=$(mc ls $MINIO_ALIAS | awk '{print $5}')

for bucket in $buckets
do
    # 檢查當前 bucket 是否有配額設置
    # quota=$(mc quota info $MINIO_ALIAS/$bucket --json | jq -r '.size')
    quota=$(mc quota info $MINIO_ALIAS/$bucket --json | jq -r '.quota')
    if [ "$quota" == "null" ]; then
        # 如果沒有配額，則設置配額為 3GB
        mc quota set $MINIO_ALIAS/$bucket --size $DEFAULT_QUOTA
        echo "Set quota for bucket '$bucket' to $DEFAULT_QUOTA"
    else
        echo "Bucket '$bucket' already has a quota set."
    fi
done