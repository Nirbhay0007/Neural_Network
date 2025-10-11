function decay(iteration,a_0=0.1,dk=0.01,)
    alpha=a_0/(1+(dk*iteration))
    return alpha

end

decay(10000)