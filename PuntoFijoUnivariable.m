f=@(x)(3*x.^3-tan(x)+x.^2);
n = 1e3;
x=linspace(-1,1,1000);
plot(x,f(x),'b',x,x*0,'k');
%axis([-1 1 -2 2])

%Se despejan todas las x de la funcion 
g2=@(x)(((tan(x)-x.^2)/3).^(1/3))
g3=@(x)(atan(3*x.^3+x.^2))

%Se derivan cada funcion
dg1=@(x)((sec(x).^2-9*x.^2)./(2*sqrt(tan(x)-3*x.^3)))%b
dg2=@(x)((sec(x).^2-2*x)./(3^(4/3)*(tan(x)-x.^2).^(2/3)))%r
dg3=@(x)(9*x.^2+2*x)./((3*x.^3+x.^2).^2+1)%m

%VER CUAL CONVERGE MAS RAPIDO(MAS CERCAS DE 0)
%x=-0.25:.001:.5;
x=linspace(-0.25,0.5,100);
plot(x,abs(dg1(x)),'b',x,dg2(x),'r',x,dg3(x),'m',x,1+0*x,'k')

n=10;
sal=[];
x0=.25;
for k=1:n
  x1=g2(x0);
  errAbs=abs(x0-x1);
  sal=[sal; [x1 errAbs errAbs/abs(x1)]];
  %para while x0=x1;
endfor
sal

