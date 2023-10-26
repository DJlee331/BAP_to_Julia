using Turing
using LinearAlgebra: I
using Statistics: mean, std
using Random: seed!
seed!(123)

######
μ = 1.
σ = 1.
X = randn(3)*σ + μ*ones(3,1)
####

using CSV
using DataFrames

data = CSV.read("C:/Users/ldjld/Desktop/BAP-master/code/data/mauna_loa_CO2.csv", DataFrame);
first(data,4)

using Plots
using LaTeXStrings
plot(data[:,1],data[:,2],label=L"$C0_{2}$ Emission",lc=:blue)
xlabel!("Year")
title!(L"$C0_{2}$ Emission")
ylabel!(L"$CO_{2}$ (ppmv)")

######
using Distributions
n_params = [1, 2, 4]  # Number of trials
p_params = [0.25, 0.5, 0.75]  # Probability of success
pmf=zeros(maximum(n_params)+2,1)
pmfstacked=zeros(maximum(n_params)+2,length(n_params)*length(p_params))
for i=1:length(n_params)
    for j = 1:length(p_params)
        D = Binomial(n_params[i],p_params[j])
            for k=0:maximum(n_params)+1
                pmf[k+1]= pdf(D,k)
            end
        pmfstacked[:,i*length(p_params)+j-length(p_params)] =  pmf
    end
end

p1 = bar(range(1,maximum(n_params)+2),pmfstacked[:,1],title="p = "*string(p_params[1]),width=0.5,ylabel="N ="*string(n_params[1]))
p2 = bar(range(1,maximum(n_params)+2),pmfstacked[:,2],title="p = "*string(p_params[2]),width=0.5)
p3 = bar(range(1,maximum(n_params)+2),pmfstacked[:,3],title="p = "*string(p_params[3]),width=0.5)
p4 = bar(range(1,maximum(n_params)+2),pmfstacked[:,4],ylabel="N = "*string(n_params[2]),width=0.5)
p5 = bar(range(1,maximum(n_params)+2),pmfstacked[:,5])
p6 = bar(range(1,maximum(n_params)+2),pmfstacked[:,6])
p7 = bar(range(1,maximum(n_params)+2),pmfstacked[:,7],ylabel="N = "*string(n_params[3]),width=0.5)
p8 = bar(range(1,maximum(n_params)+2),pmfstacked[:,8])
p9 = bar(range(1,maximum(n_params)+2),pmfstacked[:,9])

plot(p1,p2,p3,p4,p5,p6,p7,p8,p9,layout=(3,3),label="")

############

using PlotlyJS
params=[0.5, 1, 2, 3]
k=length(params)
x=range(0,1,100)
p=[plot()]

for i = 1:length(params)
    for j = 1:length(params)
        D=Beta(params[i],params[j])
        if i==1
            p=[p plot(x->pdf(D,x),xlims=(0,1),ylims=(0,3),title="α = "*string(params[j]))]
        
        elseif j ==1
            p=[p plot(x->pdf(D,x),xlims=(0,1),ylims=(0,3),ylabel="β = "*string(params[i]))]                
        else
            p=[p plot(x->pdf(D,x),xlims=(0,1),ylims=(0,3))]
        end     # add_trace!(fig,p,row=i,col=j)
    end
end
p[2] = plot(x->pdf(Beta(params[1],params[1]),x),title="α = 0.5",ylabel="β=0.5",xlims=(0,1),ylims=(0,3))
plot(p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9],p[10],p[11],p[12],p[13],
p[14],p[15],p[16],p[17],label="",ylims=(0,3))

### Subplot 그리는게 너무 불편하고 기능도 약하다...!

@model function binom_posterior(N,y)
    #priors
    p ~ Beta(α,β)
    
    # Posterior
    return y ~ Beta(α+y, β+N-y)
end;

n_trials = [0, 1, 2, 3, 4, 8, 16, 32, 50, 150];
true_p = 0.35; 
data = [rand(Binomial(n_trials[i],true_p)) for i=1:length(n_trials)]
# 난수 생성으로 데이터 만듬
beta_params = [(0.5,0.5), (1,1), (20,20)]

z=binom_posterior(n_trials[i],data[i])
1
# plt.figure(figsize=(10, 8))

# n_trials = [0, 1, 2, 3, 4, 8, 16, 32, 50, 150]
# data = [0, 1, 1, 1, 1, 4, 6, 9, 13, 48]
# theta_real = 0.35

# beta_params = [(1, 1), (20, 20), (1, 4)]
# dist = stats.beta
# x = np.linspace(0, 1, 200)

# for idx, N in enumerate(n_trials):
#     if idx == 0:
#         plt.subplot(4, 3, 2)
#         plt.xlabel('θ')
#     else:
#         plt.subplot(4, 3, idx+3)
#         plt.xticks()
#     y = data[idx]
#     for (a_prior, b_prior) in beta_params:
#         p_theta_given_y = dist.pdf(x, a_prior + y, b_prior + N - y)
#         plt.fill_between(x, 0, p_theta_given_y, alpha=0.7)

#     plt.axvline(theta_real, ymax=0.3, color='k')
#     plt.plot(0, 0, label=f'{N:4d} trials\n{y:4d} heads', alpha=0)
#     plt.xlim(0, 1)
#     plt.ylim(0, 12)
#     plt.legend()
#     plt.yticks([])
# plt.tight_layout()
# plt.savefig('B11197_01_05.png', dpi=300)