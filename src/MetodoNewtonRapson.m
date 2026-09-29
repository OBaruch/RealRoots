function p = MetodoNewtonRapson(f,fdy,x,tol,x0)
  
 %f es la funcion
%fdy es la derivada de f
%x valor sobre que se evalua
%tol existen dos caso si es mayor a un se crean todas las iteraciones que se buscan 
%si es menor a uno se busca que el esrror absoluto se aserque a ese parametro
%x0 es el valor real de la funcion (En caso de no conocer el valor real colocar sqrt(2)he ignorar las columnas de los errores y colocar en toleranica culquier numero mayor a 1)

format long;
errAbs=3*10^10;
salida=[];
 if(tol>=1)
        for i=1:tol
           f=f;
           fdy=fdy;
          x=x-(f(x)/fdy(x));
          errAbs=abs(x-x0);
          errRel=errAbs/x0;
          salida=[salida; x errAbs errRel];
        endfor
    salida
    
   else
      while(errAbs>tol)
           f=f;
           fdy=fdy;
          x=x-(f(x)/fdy(x));
          errAbs=abs(x-x0);
          errRel=errAbs/x0;
          salida=[salida; x errAbs errRel];
        endwhile
    salida
      
   
  endif
  

 endfunction

 x=[-4:.1:4];
f=4.*x.^3+15.*x.^2+8.*x-4;
fdy=12*x.^2+30*x+8;


hold on
grid on
plot(x,f);
plot(x,fdy,'--');

punto=1;
tol=10;
real=.5;
MetodoNewtonRapson(f,fdy,punto,tol,real)