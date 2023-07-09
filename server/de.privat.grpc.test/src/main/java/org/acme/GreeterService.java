package org.acme;

import io.quarkus.example.EmptyRequest;
import io.quarkus.example.Greeter;
import io.quarkus.example.HelloReply;
import io.quarkus.example.HelloRequest;
import io.quarkus.grpc.GrpcService;
import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.smallrye.mutiny.subscription.MultiEmitter;

@GrpcService
public class GreeterService implements Greeter {

    private String name;
    private Multi<String> sourceMulti;
    private Multi<String> replayMulti;

    private MultiEmitter<? super String> emitter;

    public GreeterService() {
        super();
        sourceMulti = Multi.createFrom().emitter(emitter -> {
            this.emitter = emitter;
        });

        replayMulti = Multi.createBy().replaying().upTo(1).ofMulti(sourceMulti);

    }

    @Override
    public Uni<HelloReply> sayHello(HelloRequest request) {
        this.name = request.getName();
        emitter.emit(request.getName());
        return Uni.createFrom().item(HelloReply.newBuilder().setMessage("Hello " + request.getName()).build());
    }

    @Override
    public Multi<HelloReply> sayHelloStream(EmptyRequest request) {
        return replayMulti.onItem()
                .transform(n -> HelloReply.newBuilder().setMessage("Hello " + name).build());
    }
}
