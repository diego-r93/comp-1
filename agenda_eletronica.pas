program tabalho2_2005_2;

{Autor: Diego Rodrigues da Silva - DRE: 115034285}

uses 
	crt, diegoUnit;

type
	registro = RECORD
		Nome:string;
		DRE:integer;
		Notas:array[1..2] of real;
		Media:real;
		Faltas:integer;
	end;
	regFile = file of registro; 
	ptrReg = ^reg;
	reg = record
		nomeArq:string;
		arquivo:regFile;
		prox, ant:ptrReg;
	end;


{Procedimentos e funções}


procedure MenuPrincipal;	{Menu principal do programa}
begin
   clrscr;
   writeln(' ____________________________________________________________ ');
   writeln('|                            MENU                            |');
   writeln('|------------------------------------------------------------|');
   writeln('|OPÇÕES:                                                     |');
   writeln('|------------------------------------------------------------|');
   writeln('|[1] - Abrir turma                                           |');
   writeln('|------------------------------------------------------------|');
   writeln('|[2] - Fechar turma                                          |');
   writeln('|------------------------------------------------------------|');
   writeln('|[3] - Remover turma                                         |');
   writeln('|------------------------------------------------------------|');
   writeln('|[4] - Incluir aluno                                         |');
   writeln('|------------------------------------------------------------|');
   writeln('|[5] - Remover Aluno                                         |');
   writeln('|------------------------------------------------------------|');
   writeln('|[6] - Editar Aluno                                          |');
   writeln('|------------------------------------------------------------|');
   writeln('|[7] - Consultar Turma                                       |');
   writeln('|------------------------------------------------------------|');
   writeln('|[8] - Listar Alunos                                         |');
   writeln('|------------------------------------------------------------|');
   writeln('|[0] - Sair                                                  |');
   writeln('|____________________________________________________________|');
   writeln;
   write('Opção: ');
end;



procedure MenuAux;	{Menu Auxiliar do programa}
begin
   clrscr;
   writeln(' ___________________________________________________________ ');
   writeln('|                     CONSULTA DE TURMA                     |');
   writeln('|-----------------------------------------------------------|');
   writeln('|OPÇÕES:                                                    |');
   writeln('|-----------------------------------------------------------|');
   writeln('|[1] - Buscar um aluno                                      |');
   writeln('|-----------------------------------------------------------|');
   writeln('|[2] - Buscar alunos aprovados                              |');
   writeln('|-----------------------------------------------------------|');
   writeln('|[3] - Buscar alunos reprovados por média                   |');
   writeln('|-----------------------------------------------------------|');
   writeln('|[4] - Buscar alunos reprovados por falta                   |');
   writeln('|-----------------------------------------------------------|');
   writeln('|[0] - Retornar ao Menu Principal                           |');
   writeln('|___________________________________________________________|');
   writeln;
   write('Opção: ');
end;



{Procedimento para abrir arquivo e inserir em uma lista duplamente encadeada em ordem alfabética}


procedure AbrirArquivo(var descritor:RegFile; var ptrInicio:ptrReg; var ptrUltimo:ptrReg);
var
   arq:string;
	ptrAux:ptrReg;
	final:boolean;
	aux:ptrReg;
begin
   clrscr;
   write('Digite o nome do arquivo que se deseja abrir (No máximo 10 caracteres): ');
   StringCheck(1, 10, arq);   {Testa se o valor digitado é uma string e as dimensões dessa string}
   Assign(descritor, arq+'.dat');  {Associa ao arquivo o nome digitado}
   {$I-}
   reset(descritor);  {Tenta abrir o arquivo, se der erro ele cria o arquivo}
   {$I+}
   if (IOResult = 2) then
      rewrite(descritor);

   new(ptrAux);  {Aloca um espaço na memória para o ponteiro auxiliar} 
	ptrAux^.arquivo:= descritor;	
   ptrAux^.nomeArq:= arq;
   ptrAux^.prox:= nil;
   if ptrInicio= nil then		{Se a lista estiver vazia}
   begin
      ptrInicio:= ptrAux;		{O ponteiro início recebe o auxiliar}
      ptrInicio^.ant:= nil;	{O anterior do início recebe nil, pois ele é o primeiro}
   end
   else		{Se ouver outros elementos na lista}
   begin
		if (ptrInicio^.nomeArq < ptrAux^.nomeArq) then   {Se o nome do arquivo inicial for menor do que o arquivo adicionado}
		begin
			aux:= ptrInicio;		{O segundo ponteiro auxiliar recebe o ponteiro inicial}
			final:= false;			
			while not(final) do	{Enquanto a variável de controle não for true}
			begin
				if (aux^.prox = nil) then	{Se só existe um elemento na lista}
				begin
					ptrAux^.prox:= nil;	{O próximo do ponteiro auxiliar recebe nil}
					aux^.prox:= ptrAux;	{O próximo do segundo ponteiro auxiliar recebe o ponteiro auxiliar}
					ptrAux^.ant:= aux;	{O anterior do ponteiro auxiliar recebe o segundo auxliar}
					final:= true;		
				end							{com esses procedimentos o arquivo adicionado entra depois do arquivo que existia}
				else
				begin																 {Caso não seja o único elemento da lista}
					if (aux^.prox^.nomeArq > ptrAux^.nomeArq) then   {Se o nome do arquivo seguinte for maior do que o nome do arquivo adicionado}
					begin
						ptrAux^.prox:= aux^.prox;   {Coloca o arquivo entre o primeiro e o seguinte}
						aux^.prox:= ptrAux;			 
						ptrAux^.ant:= aux;
						final:= true;					 
					end
					else                    {Se o nome do arquivo seguinte for menor do que o nome do arquivo adicionado}
						aux:= aux^.prox;		{Passa para o próximo arquivo}
				end;
			end;  
		end
		else			{se o nome do arquivo inicial for maior do que o nome do arquivo adicionado}					
		begin
			ptrAux^.prox:= ptrInicio;		{O arquivo é colocado antes do primeiro e passa a ser o primeiro agora}
			ptrInicio:= ptrAux;
			ptrAux^.ant:= nil;
		end;
	end;
	
	if (ptrAux^.prox = nil) then  {Caso a lista esteja vazia, o último é igual ao primeiro}
	   ptrUltimo:= ptrAux;

end;



{Procedimento para exibir as turmas que estão abertas}


procedure TurmasAbertas(ptrInicio:ptrReg);
var
   ptrAux:ptrReg;
begin
   ptrAux:=ptrInicio;
	writeln(' _______________________________ ');	
	writeln('|        Turmas Abertas         |');
	writeln('|-------------------------------|');
   while ptrAux <> nil do		{Se o ponteiro auxiliar for nil não tem nenhum arquivo aberto, ou chegou no final da lista}
   begin
	   writeln('|       ', ptrAux^.nomeArq:10, '              |');			{Imprime todos os arquivos até o final da lista}
		writeln('|-------------------------------|');
		ptrAux:=ptrAux^.prox;   {Passa para o próximo arquivo}
   end;
	
	writeln('|_______________________________|');
	writeln;
end;



{Função para buscar o nome de uma turma na lista de arquivos abertos, que retorna a posição da memória em que se encontra a turma}


function BuscarTurma(ptrInicio:ptrReg):ptrReg;
var
   ptrAux:ptrReg;
   achei:boolean;
   nomebusca:string;
begin
   write('Digite o nome da turma (No máximo 10 caracteres): ');
   StringCheck(1, 10, nomebusca);		{Busca o nome da turma a partir do nome digitado}
   BuscarTurma:= nil;		
   achei:= false;
   ptrAux:= ptrInicio;		{O auxiliar recebe o primeiro ponteiro da lista}
   if (ptrInicio <> nil) then		{Se existe algum arquivo na lista}
      repeat
         if (ptrAux^.nomeArq = nomebusca) then		{Repete o procedimento até o nome do arquivo corrente ser igual ao do arquivo procurado}
			   achei:= true
			else
            ptrAux:= ptrAux^.prox;						{Se não for igual passa para o próximo}
      until ((ptrAux = nil) or (achei));
      if (ptrAux = nil) then								{Se o resultado da busca for nil não existe turma com esse nome}
		begin
			writeln;
         writeln('TURMA NÃO ENCONTRADA');
			writeln;
		end;
	
	BuscarTurma:= ptrAux;			{A função recebe o ponteiro auxiliar, que vai ser nil se não achar o nome buscado}
end;



{Procedimento para remover uma turma da lista de turmas abertas e apagar a mesma}


procedure RemoverTurma(var descritor:RegFile; var ptrInicio:ptrReg; var ptrUltimo:ptrReg);
var
	ptrAux:ptrReg;
begin
   ptrAux:= BuscarTurma(ptrInicio);		{O ponteiro auxiliar recebe o resultado da busca de turmas}
	if (ptrAux <> nil) then				   {Se o auxiliar for nil a lista está vazia}
   begin
		descritor:= ptrAux^.arquivo;		{Aponta o arquivo a ser removido}
      if (ptrAux^.ant = nil) then      {É o primeiro}
      begin
         ptrInicio:= ptrinicio^.prox;
         if (ptrAux^.prox = nil) then  {Primeiro e último}
            ptrUltimo:= nil
         else                          {Primeiro sem ser ultimo}
            ptrAux^.prox^.ant:= nil;
      end
      else
		begin
         if ptrAux^.prox = nil then    {É o último}
         begin
            ptrAux^.ant^.prox:= nil;
            ptrUltimo:= ptrAux^.ant;
         end
         else			{Faz o ponteiro anterior ao arquivo a ser removido apontar para o seguinte ao arquivo a ser removido}
         begin
            ptrAux^.ant^.prox:= ptrAux^.prox;  
            ptrAux^.prox^.ant:= ptrAux^.ant;
         end;
		end;

	writeln;
   writeln('Turma ', ptrAux^.nomeArq, ' Foi apagada! ');
	close(descritor);		{Fecha a turma a ser removida}
	erase(descritor);		{Apaga o arquivo associado a turma a ser removida}
   dispose(ptrAux);		{Remove a posição na memória associada ao arquivo}

	end;
end;



{Procedimento para remover uma turma da lista de turmas abertas e fechar a mesma}


procedure FecharArquivo(var descritor:RegFile; var ptrInicio:ptrReg; ptrUltimo:ptrReg);
var
	ptrAux:ptrReg;
begin
   ptrAux:= BuscarTurma(ptrInicio);    {O ponteiro auxiliar recebe o resultado da busca de turmas}
	if (ptrAux <> nil) then					{Se o auxiliar for nil a lista está vazia}
   begin
		descritor:= ptrAux^.arquivo;     {Aponta o arquivo a ser removido}
      if (ptrAux^.ant = nil) then      {É o primeiro}
      begin
         ptrInicio:= ptrinicio^.prox;
         if (ptrAux^.prox = nil) then  {Primeiro e último}
            ptrUltimo:= nil
         else                          {Primeiro sem ser ultimo}
            ptrAux^.prox^.ant:= nil;
      end
      else
		begin
         if ptrAux^.prox = nil then    {É o último}
         begin
            ptrAux^.ant^.prox:= nil;
            ptrUltimo:= ptrAux^.ant;
         end
         else			{Faz o ponteiro anterior ao arquivo a ser removido apontar para o seguinte ao arquivo a ser removido}
         begin
            ptrAux^.ant^.prox:= ptrAux^.prox;
            ptrAux^.prox^.ant:= ptrAux^.ant;
         end;
      end;
		
      writeln;
		writeln('Turma ', ptrAux^.nomeArq, ' Foi fechada! ');
		close(descritor);    {Fecha a turma a ser removida}
		dispose(ptrAux);		{Remove a posição da memória associada ao arquivo}

	end;
end;



{Procedimento para inserir alunos, em ordem alfabética, na turma selecionada}


procedure IncluirAluno(var descritor:RegFile; var reg:Registro; ptrInicio:ptrReg; ptrUltimo:ptrReg);
var
	ptrAux:ptrReg;
	aux:Registro;
	troca:boolean;
	final:boolean;
	posicao:integer;
	opcao:char;
	mensagem:string;
begin
	final:= false;
	ptrAux:= BuscarTurma(ptrInicio);    {O ponteiro auxiliar recebe o resultado da busca de turmas}
	if ptrAux <> nil then					{Se o auxiliar for nil a lista está vazia}
	begin
		descritor:= ptrAux^.arquivo;		{Associa a turma correspondente}
		posicao:= 16001;						{Serve para determinar o DRE}

		while final = false do
		begin
			if FileSize(descritor) <> 0 then			{Se houver pelo menos um reggistro salvo no arquivo}
			begin
				seek(descritor, 0);						{Procura qual é o maior DRE no arquivo e salva o valor acrescido da unidade}
   			while not Eof(descritor) do
      		begin
         		read(descritor, reg);
         		if (reg.DRE > posicao) then
           			posicao:= reg.DRE;
				end;
				posicao:= posicao + 1;
			end
			else
				posicao:= 16001;							{Caso não o arquivo esteja vazio o DRE será o valor inicial}
			
			seek(descritor, FileSize(descritor));	{Vai para o final do arquivo, para adicionar o próximo registro}
			write('Digite o nome do aluno (No máximo 10 caracteres): ');
			StringCheck(1, 10, reg.Nome);
			reg.DRE:= posicao;
			write('Digite a nota da P1: ');
			RealCheck(reg.Notas[1]);
			write('Digite a nota da P2: ');
			RealCheck(reg.Notas[2]);
			reg.Media:= (reg.Notas[1] + reg.Notas[2])/2;
			write('Digite o número de faltas: ');
			IntCheck(reg.Faltas);	
			write(descritor, reg);						{Escreve no arquivo o registro salvo}
			     	
			repeat											{Ordenação do registro no arquivo}
				troca:= false;
				seek(descritor, 0);																		
				while (filepos(descritor) < filesize(descritor)-1) do			
     			begin
        			read(descritor, reg);				{Salva em dois registros e compara o maior}
        			read(descritor, aux);
        			if (reg.nome > aux.nome) then
        			begin
         			seek(descritor, filepos(descritor)-2);
         			write(descritor, aux);			{Escreve os registros no arquivo em ordem}
         			write(descritor, reg);
         			troca:=true;
        			end
        			else
        				seek (descritor, filepos(descritor)-1);	{Posiciona o cursor no final do arquivo}
     			end;
			until not troca;								{Caso nenhuma troca de posição seja feita ele encerra a ordenação}
   						
			mensagem:= 'Deseja incluir mais alunos? ';
			opcao:= Confirmar(mensagem);
			if (opcao = 'N') then
				final:= true;
							
		end;
	end;
end;



{Função para buscar um nome em um arquivo, que retorna a posição do registro ou -1 se não encontrar}


function BuscarNome(var descritor:RegFile; reg:Registro; ptrInicio:ptrReg; ptrUltimo:ptrReg):integer;
var
	ptrAux:ptrReg;
	busca:string;
	aux:integer;
begin
	ptrAux:= BuscarTurma(ptrInicio);
	if ptrAux <> nil then
	begin
   	descritor:= ptrAux^.arquivo;
		seek(descritor, 0);
		write('Digite o nome a ser procurado: ');
		StringCheck(1, 10, busca);
		writeln;
		writeln('Pesquisando por ', busca, ' .....');
		writeln;
		read(descritor, reg);

		while not Eof(descritor) and (busca <> reg.nome) do    {vai buscar até encontrar ou chegar no final do arquivo}
			read(descritor, reg);
		
		if reg.nome = busca then						
				BuscarNome:= FilePos(descritor)-1		{Caso encontre iguala a função à posição de registro menos um pois o read avança de posição}
			else
				BuscarNome:= -1;
		
		aux:= BuscarNome;
		
		if (BuscarNome = -1) then
			writeln('Nome não encontrado')
		else
		begin
			seek(descritor, aux);																		{Imprime o valor encontrado}
			writeln('>>O resultado da busca foi a posição ', aux, ' do arquivo');
			writeln;
			writeln(' _______________________________________________________________________________________ ');
			writeln('|     NOME             DRE            P1         P2         MÉDIAS         FALTAS       |');
   		writeln('|---------------------------------------------------------------------------------------|');
			writeln('|  ', reg.NOME:10, '         ', reg.DRE, '          ', reg.Notas[1]:2:2, '       ', reg.Notas[2]:2:2, '         ', reg.Media:2:2, '            ', reg.Faltas:2, '         |');
			writeln('|---------------------------------------------------------------------------------------|');
			writeln('|_______________________________________________________________________________________|');
   		writeln;
		end;
	end;
end;



{Função para buscar um DRE em um arquivo, que retorna a posição do registro ou -1 se não encontrar}


function BuscarDRE(var descritor:RegFile; reg:Registro; ptrInicio:ptrReg; ptrUltimo:ptrReg):integer;
var
	ptrAux:ptrReg;
	busca:integer;
	aux:integer;
begin
	ptrAux:= BuscarTurma(ptrInicio);
	if ptrAux <> nil then
	begin
   	descritor:= ptrAux^.arquivo;
   	seek(descritor, 0);
   	write('Digite o DRE a ser procurado: ');
   	IntCheck(busca);
		writeln;
		writeln('Pesquisando por ', busca, ' .....');
      writeln;
		read(descritor, reg);

    	while not Eof(descritor) and (busca <> reg.DRE) do    {vai buscar até encontrar ou chegar no final do arquivo}
   	  	read(descritor, reg);
 
     	if reg.DRE = busca then
         	BuscarDRE:= FilePos(descritor)-1     {Caso encontre iguala a função à posição de registro menos um pois o read avança de posição}
      	else
         	BuscarDRE:= -1;
	
   	aux:= BuscarDRE;

   	if (BuscarDRE = -1) then
   		writeln('DRE Não encontrado')
   	else 
   	begin
			seek(descritor, aux);
			writeln('>>O resultado da busca foi a posição ', aux, ' do arquivo');          {Imprime o valor encontrado}
      	writeln;
			writeln(' _______________________________________________________________________________________ ');
			writeln('|     NOME             DRE            P1         P2         MÉDIAS         FALTAS       |');
   		writeln('|---------------------------------------------------------------------------------------|');
			writeln('|  ', reg.NOME:10, '         ', reg.DRE, '          ', reg.Notas[1]:2:2, '       ', reg.Notas[2]:2:2, '         ', reg.Media:2:2, '            ', reg.Faltas:2, '         |');
			writeln('|---------------------------------------------------------------------------------------|');
			writeln('|_______________________________________________________________________________________|');
   		writeln;
		end;
	end;
end;



{Procedimento para mostrar os alunos aprovados, com nota maior ou igual a sete}


procedure Aprovados(var descritor:RegFile; reg:registro; ptrInicio:ptrReg; ptrUltimo:ptrReg);
var
	ptrAux:ptrReg;
begin
	ptrAux:= BuscarTurma(ptrInicio);
	if ptrAux <> nil then
	begin
   	descritor:= ptrAux^.arquivo;
   	seek(descritor, 0);
     	writeln('>>Alunos aprovados:');
		writeln;
		writeln(' _______________________________________________________________________________________ ');
		writeln('|     NOME             DRE            P1         P2         MÉDIAS         FALTAS       |');
  		writeln('|---------------------------------------------------------------------------------------|');
    	while not Eof(descritor) do
   	begin
		  	read(descritor, reg);
      	if reg.Media >= 7 then
			begin
				writeln('|  ', reg.NOME:10, '         ', reg.DRE, '          ', reg.Notas[1]:2:2, '       ', reg.Notas[2]:2:2, '         ', reg.Media:2:2, '            ', reg.Faltas:2, '         |');
				writeln('|---------------------------------------------------------------------------------------|');
			end;
		end;
		writeln('|_______________________________________________________________________________________|');
   	writeln;
	end;
end;



{Procedimento para mostrar os alunos reprovados por média, menor que sete}


procedure ReprovadosMedia(var descritor:RegFile; reg:registro; ptrInicio:ptrReg; ptrUltimo:ptrReg);
var
	ptrAux:ptrReg;
begin
	ptrAux:= BuscarTurma(ptrInicio);
	if ptrAux <> nil then
	begin
   	descritor:= ptrAux^.arquivo;
   	seek(descritor, 0);
     	writeln('>>Alunos reprovados por nota:');
		writeln;
		writeln(' _______________________________________________________________________________________ ');
		writeln('|     NOME             DRE            P1         P2         MÉDIAS         FALTAS       |');
  		writeln('|---------------------------------------------------------------------------------------|');
    	while not Eof(descritor) do
   	begin
		  	read(descritor, reg);
      	if reg.Media < 7 then
			begin
				writeln('|  ', reg.NOME:10, '         ', reg.DRE, '          ', reg.Notas[1]:2:2, '       ', reg.Notas[2]:2:2, '         ', reg.Media:2:2, '            ', reg.Faltas:2, '         |');
				writeln('|---------------------------------------------------------------------------------------|');
			end;
		end;
		writeln('|_______________________________________________________________________________________|');
   	writeln;
	end;
end;

			

{Procedimento para mostrar os alunos reprovados por faltas, maior do que quatro}


procedure ReprovadosFalta(var descritor:RegFile; reg:registro; ptrInicio:ptrReg; ptrUltimo:ptrReg);
var
	ptrAux:ptrReg;
begin
	ptrAux:= BuscarTurma(ptrInicio);
	if ptrAux <> nil then
	begin
   	descritor:= ptrAux^.arquivo;
   	seek(descritor, 0);
     	writeln('>>Alunos reprovados por falta:');
		writeln;
		writeln(' _______________________________________________________________________________________ ');
		writeln('|     NOME             DRE            P1         P2         MÉDIAS         FALTAS       |');
  		writeln('|---------------------------------------------------------------------------------------|');
    	while not Eof(descritor) do
   	begin
		  	read(descritor, reg);
      	if reg.Faltas > 4 then
			begin
				writeln('|  ', reg.NOME:10, '         ', reg.DRE, '          ', reg.Notas[1]:2:2, '       ', reg.Notas[2]:2:2, '         ', reg.Media:2:2, '            ', reg.Faltas:2, '         |');
				writeln('|---------------------------------------------------------------------------------------|');
			end;
		end;
		writeln('|_______________________________________________________________________________________|');
   	writeln;
	end;
end;

			


{Procedimento para apagar um registro salvo em um arquivo}


procedure ApagarRegistro(var descritor:RegFile; var reg:registro; ptrInicio:ptrReg; ptrUltimo:ptrReg);
var	
	aux:integer;
	mensagem:string;
begin
   aux:= BuscarNome(descritor, reg, ptrInicio, ptrUltimo);					{O ponteiro auxiliar recebe o resultado da busca de turmas}
	if aux <> -1 then
	begin
		mensagem:= 'Deseja realmente excluir o registro do aluno?';
		if (Confirmar(mensagem) = 'S') then
		begin
			seek(descritor, aux+1);													{Vai para a posição seguinte ao arquivo que se deseja remover}
			while not Eof(descritor) do											{Enquanto não chegar ao final do arquivo}
			begin
				read(descritor, reg);								{Lê o registro seguinte ao que se deja excluir e avaça para a próxima posição}
				seek(descritor, FilePos(descritor)-2);			{Posiciona o ponteiro no registro que se deseja remover}
				write(descritor, reg);								{Escreve o registro seguinte em cima do valor a remover e avança para a prima posição}
				seek(descritor, FilePos(descritor)+1);			{Posiciona o cursor na próxima posição}	
			end;
			seek(descritor, FileSize(descritor)-1);			{Retorna para a posição anterior}
			truncate(descritor);										{Apara todos os registros a partir da posição} 
		end;
	end;
	close(descritor);												
	reset(descritor);												
	writeln;
	writeln('Nome apagado!');
	writeln;
end;



{Procedimento para editar o registro de um aluno}


procedure EditarAluno(var descritor:RegFile; var reg:registro; ptrInicio:ptrReg; ptrUltimo:ptrReg);
var
	DREaux:integer;
	aux:integer;
	opcao:integer;
	mensagem:string;
	final:boolean;
begin
	final:= false;
	while final = false do
	begin
		writeln('Como deseja efetuar a pesquisa?');
		writeln;
		write('Digite 1 para pesquisar por NOME e 2 para pesquisar por DRE: ');
		IntCheck(opcao);
		if opcao = 1 then
		begin
			aux:= BuscarNome(descritor, reg, ptrInicio, ptrUltimo);
			final:= true;
		end
		else
			if opcao = 2 then
			begin
				aux:= BuscarDRE(descritor, reg, ptrInicio, ptrUltimo);
				final:=true;
			end
			else
			begin
				writeln;
				writeln('ERRO DIGITE UMA OPÇÃO VÁLIDA');
				writeln;
			end;

   writeln;
	end;
   if aux <> -1 then
   begin
      mensagem:= 'Deseja realmente alterar o registro do aluno? ';
      if (Confirmar(mensagem) = 'S') then
      begin
			seek(descritor, aux);			{Vai para a posição a ser editada}
			read(descritor, reg);			{Lê o registro para salvar o DRE}
			DREaux:= reg.DRE;
			seek(descritor, aux);		
        	write('Digite o novo nome (No máximo 10 caracteres): ');		{Escreve em cima do registro}
			StringCheck(1, 10, reg.Nome);
			reg.DRE:= DREaux;
			write('Digite a nota da P1: ');
     	   RealCheck(reg.Notas[1]);
     		write('Digite a nota da P2: ');
      	RealCheck(reg.Notas[2]);
      	reg.Media:= (Reg.Notas[1] + Reg.Notas[2])/2;
      	write('Digite o número de faltas: ');
      	IntCheck(reg.Faltas);
			write(descritor, reg);
		end;
	end;
end;



{Imprime em forma de plenilha todos os registros salvos}


procedure ImprimirArquivo(var descritor:RegFile; ptrInicio:ptrReg; ptrUltimo:ptrReg);
var
	ptrAux:ptrReg;
	reg:registro;
begin
	ptrAux:= BuscarTurma(ptrInicio);
	if ptrAux <> nil then
	begin
		descritor:= ptrAux^.arquivo;
		seek(descritor, 0);					{Vai para o primeiro registro}
		writeln(' _______________________________________________________________________________________ ');
		writeln('|                                   PLANILHA DE ALUNOS                                  |');
		writeln('|---------------------------------------------------------------------------------------|');
		writeln('|     NOME             DRE            P1         P2         MÉDIAS         FALTAS       |');
   	writeln('|---------------------------------------------------------------------------------------|');
   	while not Eof(descritor) do		{Enquanto não chegar ao final do arquivo}
		begin
			read(descritor, reg);			{Lê o registro, avaça para o próximo e imprime o registro lido}
			writeln('|  ', reg.NOME:10, '         ', reg.DRE, '          ', reg.Notas[1]:2:2, '       ', reg.Notas[2]:2:2, '         ', reg.Media:2:2, '            ', reg.Faltas:2, '         |');
			writeln('|---------------------------------------------------------------------------------------|');
		end; 

		writeln('|_______________________________________________________________________________________|');

	end;
end;




{******************************Programa Principal******************************}



var
	arq:regFile;
	regi:registro;
   ptrInicio:ptrReg;				{Variáveis do programa principal, são todas variáveis locais}
   ptrUltimo:ptrReg;
   opcao:integer;
   final:boolean;
begin
      ptrInicio:= nil;				
      ptrUltimo:= nil;
      final:= false;
      while final = false do
      begin
         MenuPrincipal;
		   IntCheck(opcao);
         case opcao of
               0:final:=true;
               1:begin
						clrscr;
						writeln;
						AbrirArquivo(arq, ptrInicio, ptrUltimo);
                 	writeln;
						TurmasAbertas(ptrInicio);
						writeln;
                  write('Pressione qualquer tecla para retornar ao MENU');
                  readkey;
               end;
					2:begin
						clrscr;
						TurmasAbertas(ptrInicio);
						writeln;
						FecharArquivo(arq, ptrInicio, ptrUltimo);
                 	writeln;
                  write('Pressione qualquer tecla para retornar ao MENU');
                  readkey;
               end;
					3:begin
						clrscr;
						TurmasAbertas(ptrInicio);
						writeln;
						RemoverTurma(arq, ptrInicio, ptrUltimo);
                 	writeln;
                  write('Pressione qualquer tecla para retornar ao MENU');
                  readkey;
               end;
					4:begin
						clrscr;
						TurmasAbertas(ptrInicio);
						writeln;
						IncluirAluno(arq, regi, ptrInicio, ptrUltimo);
                 	writeln;
                  write('Pressione qualquer tecla para retornar ao MENU');
                  readkey;
               end;
					5:begin
						clrscr;
						TurmasAbertas(ptrInicio);
						writeln;
						ApagarRegistro(arq, regi, ptrInicio, ptrUltimo);
                 	writeln;
                  write('Pressione qualquer tecla para retornar ao MENU');
                  readkey;
               end;
					6:begin
						clrscr;
						TurmasAbertas(ptrInicio);
						writeln;
						EditarAluno(arq, regi, ptrInicio, ptrUltimo);
                 	writeln;
                  write('Pressione qualquer tecla para retornar ao MENU');
                  readkey;
               end;
					7:begin
						clrscr;
						while final = false do
						begin
							MenuAux;
							IntCheck(opcao);
							case opcao of
								0:final:= true;
								1:begin
									BuscarNome(arq, regi, ptrInicio, ptrUltimo);
									writeln;
                 				write('Pressione qualquer tecla para retornar ao MENU');
                  			readkey;
               			end;
								2:begin
									Aprovados(arq, regi, ptrInicio, ptrUltimo);
									writeln;
                 				write('Pressione qualquer tecla para retornar ao MENU');
                  			readkey;
               			end;
								3:begin
									ReprovadosMedia(arq, regi, ptrInicio, ptrUltimo);
									writeln;
                 				write('Pressione qualquer tecla para retornar ao MENU');
                  			readkey;
               			end;
								4:begin
									ReprovadosFalta(arq, regi, ptrInicio, ptrUltimo);
									writeln;
                 				write('Pressione qualquer tecla para retornar ao MENU');
                  			readkey;
               			end;
								else
   						   begin
                  			writeln('ERRO! OPÇÃO INVÁLIDA');
                  			write('Pressione qualquer tecla para retornar');
                  			readkey;
               			end;
							end;
						end;
						final:= false;			
      			end;
					8:begin
						clrscr;
						TurmasAbertas(ptrInicio);
						writeln;
						ImprimirArquivo(arq, ptrInicio, ptrUltimo);
                 	writeln;
						write('Pressione qualquer tecla para retornar ao MENU');
                  readkey;
               end;
					else
               begin
                  writeln('ERRO! OPÇÃO INVÁLIDA');
                  write('Pressione qualquer tecla para retornar');
                  readkey;
               end;
         end;
      end;
end.
