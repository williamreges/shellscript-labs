echo "=== Application ==="
mkdir -p src/main/java/com/example/payment/application

echo "=== Domain ==="
mkdir -p \
src/main/java/com/example/payment/application/domain \
src/main/java/com/example/payment/application/domain/entity \
src/main/java/com/example/payment/application/domain/enum \
src/main/java/com/example/payment/application/domain/gateway

echo "=== UseCase ==="
mkdir -p \
src/main/java/com/example/payment/application/usecases \
src/main/java/com/example/payment/application/usecases/impl
#src/main/java/com/example/payment/application/usecases/mapper \
#src/main/java/com/example/payment/application/usecases/exception

echo "=== DataProvider ==="
mkdir -p \
src/main/java/com/example/payment/dataprovider \
src/main/java/com/example/payment/dataprovider/repository \
src/main/java/com/example/payment/dataprovider/repository/entity \
src/main/java/com/example/payment/dataprovider/service \
src/main/java/com/example/payment/dataprovider/service/model \
src/main/java/com/example/payment/dataprovider/service/model/input \
src/main/java/com/example/payment/dataprovider/service/model/output \
src/main/java/com/example/payment/dataprovider/mapper

echo "=== Entrypoint ==="
mkdir -p \
src/main/java/com/example/payment/entrypoint/controller \
src/main/java/com/example/payment/entrypoint/listener \
src/main/java/com/example/payment/entrypoint/model \
src/main/java/com/example/payment/entrypoint/model/request \
src/main/java/com/example/payment/entrypoint/model/response

echo "=== InfraEstructure ==="
mkdir -p \
src/main/java/com/example/payment/infraestructure \
src/main/java/com/example/payment/infraestructure/exception \
src/main/java/com/example/payment/infraestructure/exception/handler \
src/main/java/com/example/payment/infraestructure/configuration
