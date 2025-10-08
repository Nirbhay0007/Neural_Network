

using Random

# Activation functions
relu(x) = max(0, x)
drelu(x) = x > 0 ? 1.0 : 0.0

# Inputs (1 sample, 4 features)


X = [1.0 2.0 3.0 4.0]   # shape (1,4) row vector

# Random initialization
Random.seed!(42)
W = randn(4, 3)   # shape (4,3) weights
B = randn(1, 3)   # shape (1,3) biases



function forward_pass(X, W, B)

    z=W*X.+B
    a=relu(z)
    Y=sum(a)
    L=Y^2

    return z,a,Y,L

end

z,a,Y,L=forward_pass(X,W,B)
println("Initial Loss: ", L)


#creating a backwardpass
function backward_pass(X, W, B, Z, A, Y)
    dl_dy=2Y
    da_dz=drelu.(Z)
    # Gradient for weights 

    dW = zeros(size(W))
    for i in 1:size(W, 1)  # loop neurons
        for j in 1:size(W, 2)  # loop inputs
            dW[i,j]=dl_dy*da_dz[i]*X[j]
        end
    end


    # Gradient for baises
    dB=[dl_dy * 1 * da_dz[i] for i in 1:length(B)]
    return dW,dB
end

dW, dB = backward_pass(X, W, B, z, a, Y)
println("Weight gradients:\n", dW)
println("Bias gradients:\n", dB)



function updated_parameter!(W, B, dW, dB, lr)
    W.-=lr.*dW
    B.-=lr.*dB
    
end

# Single step
lr = 0.001
updated_parameter!(W, B, dW, dB, lr)
# Recalculate loss
_, _, _, newL = forward_pass(X, W, B)
println("Loss after one update: ", newL)


function train(x,W, B; lr=0.001,epochs=20)
    losses=Float64[]
    for epoch in 1:epochs

        Z, A, Y, L = forward_pass(X, W, B)
        dW, dB = backward_pass(X, W, B, Z, A, Y)
        updated_parameter!(W, B, dW, dB, lr)
        push!(losses, L)
    end
    return W, B, losses
end

W, B, losses = train(X, W, B)
losses
for i in 1:length(losses)
    println("the loss is $i : is $losses[i]")
end
# ---------------------------------------------*****************----------------------------
# Batch of 3 samples
X_batch = [1.0 2.0 3.0 4.0;
           0.5 1.0 1.5 2.0;
           2.0 0.5 1.0 3.0]   # shape (3,4)

Z_batch = X_batch * W .+ B   # shape (3,3)
A_batch = relu.(Z_batch)
Y_batch = sum(A_batch, dims=2)   # sum across neurons per sample
L_batch = sum(Y_batch.^2)        # total batch loss

# Backprop for batch
dL_dY = 2 .* Y_batch                  # shape (3,1)
dA_dZ = drelu.(Z_batch)               # shape (3,3)
dL_dZ = dL_dY .* dA_dZ                # shape (3,3)

dW_batch = X_batch' * dL_dZ           # (4,3)
dB_batch = sum(dL_dZ, dims=1)         # sum across batch → (1,3)

println("Batch weight gradients:\n", dW_batch)
println("Batch bias gradients:\n", dB_batch)
