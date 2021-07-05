# Sample
```bash

rm -rfv ./GTW_ORDERS/.adf/
rm -rfv ./GTW_ORDERS/.data/
rm -rfv ./GTW_ORDERS/src/

rm -rfv ./GTW_ORDERS/GTW_DEFINITIONS/testsuites/

rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/.data/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/SOA/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/.settings/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/testsuites/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/WSDLs/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/Schemas/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/SCA-INF/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/Events/
rm -rfv ./GTW_ORDERS/GTW_ORDERS_API/Transformations/

cd ./GTW_ORDERS

git checkout System/pom.xml
git checkout pom.xml
git checkout GTW_ORDERS.jws

cd ./GTW_ORDERS_API


git checkout GTW_ORDERS_API.jpr


git status
cd ..
git status

```