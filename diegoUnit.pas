unit diegoUnit; //Unit criada para testar as principais variáveis e confirmar ações


{Autor: Diego Rodrigues da Silva -  DRE: 115034285}

interface

procedure RealCheck(var valReal:real);
procedure DimCheck(min, max:integer; var intVal:integer);
procedure IntCheck(var intVal:integer); 
procedure BinCheck(var binVal:integer);
procedure StringCheck(min, max:integer; var stringVal:string);
function Confirmar(mensagem: string):char;

implementation


procedure RealCheck(var valReal:real);  //Teste para real
var
	correto:boolean;
	aux:integer;
begin

   	{$I-}
		
		correto:= false;
		while correto = false do
		begin
			readln(aux);
			if (IOResult <> 0) then   
				writeln ('ERRO! O VALOR DIGITADO NÃO É UM REAL. DIGITE NOVAMENTE')
    			else 
			begin
				correto:= true;
				valReal:=aux;
			end;
		end;
				

	{$I+}

end;



procedure DimCheck(min, max:integer; var intVal:integer);   //Teste para dimensão inteira
var
	correto:boolean;
	aux:integer;

begin

	{$I-}

	correto:= false;
	while correto = false do
	begin
		readln(aux);
		if (IOResult= 0) then
		begin
			if (aux >= min) and (aux <= max) then
			begin
				correto:= true;
				intVal:= aux;
			end
			else
				writeln('ERRO! DIGITE UM VALOR DENTRO DAS DIMENÇÕES.');
		end
		else
			writeln('ERRO! DIGITE UM VALOR INTEIRO.');
	end;

	{$I+}

end;

procedure IntCheck(var intVal:integer);  //Teste para inteiro
var 
	correto:boolean;  
	aux:integer;  

begin
	
	{$I-}

	correto:= false;
	while correto= false do
	begin
		readln(aux); 
 		if (IOResult = 0) then 
		begin
			correto:= true;
			intVal:= aux
		end
		else
			writeln('ERRO! DIGITE UM VALOR INTEIRO.');
   end;

	{$I+}	 

end;
  
procedure BinCheck(var binVal:integer); //Teste para binário
var 
	correto:boolean;
	aux:integer;   
begin

	{$I-}

	correto:= false;
	while correto = false do
	begin
		readln(aux);        
		if (IOResult = 0) then      
		begin
			if (aux = 0) or (aux = 1) then
			begin       
				binVal:= aux;
				correto:= true;
			end
			else
				writeln('ERRO! DIGITE SOMENTE 0 OU 1.'); 
		end
		else
			writeln('ERRO! DIGITE UM VALOR INTEIRO.');  
	end;

	{$I+}

end;

procedure StringCheck(min, max:integer; var stringVal:string); //Teste para string
var 
	aux:string;
	correto:boolean;
begin

	{$I-}

	correto:= false;
	while correto = false do
   	begin
		readln(aux);
		if (IOResult = 0) then
		begin
			if (length(aux) >= min) and (length(aux) <= max) then
			begin
				correto:= true;
				StringVal:= aux;
			end
			else
				writeln('ERRO! DIGITE UM VALOR DENTRO DAS DIMENSÕES');		
		end
		else
			writeln('ERRO! ENTRADA INVÁLIDA.');
	end;
	
	{$I+}

end;


function Confirmar(mensagem: string):char; //função para confirmar uma mensagem
var 
	resposta: char;
begin
	repeat
		write(mensagem,' [S/N] ');
		readln(resposta);
		resposta:= upcase(resposta);
		if (resposta <> 'S') and (resposta <> 'N') then 
		begin
			writeln('ERRO! RESPOSTA INVÁLIDA.'); 
		end;
	until (resposta = 'S') or (resposta = 'N');
	confirmar := resposta;
end;


end.

