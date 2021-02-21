function d = MetodoReglaFalsa(f,a,b,tol,x0)
  
%f es la funcion
%a es el putno de aproximacion por la izquierda
%b es el punto de aproximacion por la derecha
%tol existen dos caso si es mayor a un se crean todas las iteraciones que se buscan 
%si es menor a uno se busca que el esrror absoluto se aserque a ese parametro
%x0 es el valor real  (En caso de no conocer el valor real colocar sqrt(2)he ignorar las columnas de los errores y colocar en toleranica culquier numero mayor a 1)

errAbs=3*10^10;

salida=[];
  if(tol>=1)
    for k=1:tol
      m=a-((f(a)*(b-a))/(f(b)-f(a)));
        if (f(a)*f(m)<0)
          b=m;
        else
          a=m;
        endif
      errAbs=abs(x0-m);
      errRel=errAbs/abs(x0);
      salida=[salida;[a,m,b,f(a),f(m)],errAbs,errRel];
     endfor
     salida
    
   else
      while (errAbs>tol)
      m=a-((f(a)*(b-a))/(f(b)-f(a)));
        if (f(a)*f(m)<0)
          b=m;
        else
          a=m;
        endif
      errAbs=abs(x0-m);
      errRel=errAbs/abs(x0);
      salida=[salida;[a,m,b,f(a),f(m)],errAbs,errRel];
      endwhile
      salida
      
   
  endif
  

 endfunction