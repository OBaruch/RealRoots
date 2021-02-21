syms x;
f=@(x)();
fdy=@(x)(); 
fdy2=@(x)();
a=-2; b=2;  %Alredodor de los puntos que rodea metoodos cerrados
p=-3%Solo para los abiertos
tol=1e-10;
x0=-0.438842366;%Valor real de la raiz que se busca para ver la aproximacion

#METODOS DE RAIZES CERRADOS
MetodoBiseccion(f,a,b,tol,x0)
MetodoReglaFalsa(f,a,b,tol,x0)

#METODOS DE RAIZES ABIERTOS
MetodoNewtonRapson(f,fdy,p,tol,x0)
MetodoEuler(f,fdy,fdy2,p,tol,x0)



