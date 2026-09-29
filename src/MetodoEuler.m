function p = MetodoEuler(f,fdy,fdy2,x,tol,x0)
  
%f es la funcion
%fdy es la derivada de f
%fdy es la segunda derivada de f
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
              fdy2=fdy2;
              u=f(x)/fdy(x);
              t=((f(x)*fdy2(x))/(fdy(x).^2));
              x=x-((2*u)/(1+sqrt(1-2*t)));
              errAbs=abs(x-x0);
              errRel=errAbs/x0;
              salida=[salida; x errAbs errRel];
          endfor
         salida
    
       else
        while(errAbs>tol)
                f=f;
                fdy=fdy;
                fdy2=fdy2;
                u=f(x)/fdy(x);
                t=(f(x)*fdy2(x)/(fdy(x).^2));
                x=x-((2*u)/(1+sqrt(1-2*t)));
                errAbs=abs(x-x0);
                errRel=errAbs/x0;
                salida=[salida; x errAbs errRel];
          endwhile
      salida
        
     
      endif
  

 endfunction
