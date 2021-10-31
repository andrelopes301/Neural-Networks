%Trabalho realizado por:

%André Lopes - 2019139754
%Samuel Tavares - 2019126468


function principal(opcao,checkbox_p1,checkbox_p2,checkbox_p3,checkbox_p4,popupcamadas,txt_neuronios,txt_epocas,p_camada1,p_camada2,p_camada3,p_camada4,p_camada5,popuptreino,popupTop,popupsaida,Switch_Seg, txt_treino, txt_val, txt_teste)

    global tr
    %input data
    global pTrain;
    global p1;
    global p2;
    global p3;
    global p4;
    
    %targets
    global tTrain;
    global t1;
    global t2;
    global t3;
    global t4;
    
    global net;


    %Tratamento das imagens e inicializacao dos targets e inputs
 if opcao == 0    
     
    DigitDatasetPasta1 = {'imagens\Pasta1'};
    DigitDatasetPasta2 = {'imagens\Pasta2'};
    DigitDatasetPasta3 = {'imagens\Pasta3'};
    %Imagens desenhadas
    DigitDatasetPasta4 = {'imagens\Pasta4'};
 
    IDS1 = imageDatastore(DigitDatasetPasta1, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');

    IDS2 = imageDatastore(DigitDatasetPasta2, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');

    IDS3 = imageDatastore(DigitDatasetPasta3, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');

    IDS4 = imageDatastore(DigitDatasetPasta4, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');


    %PASTA 1
       p1 = zeros(30*30, 10);
        for i=1:10
            img = read(IDS1);
            imagem_reduzida = imbinarize(imresize(img,[30 30]));  
            %figure(1);
            %imshow(imagem_reduzida);
            imagem_reduzida = imagem_reduzida(:);
            p1(:,i) = imagem_reduzida;

        end
        
    t1 = zeros(10,10);
    for i=1:10
        t1(i,i)=1;
    end
%   disp(t1);

    %PASTA 2
        p2 = zeros(30*30, 100);
        for i=1:(10*10)
            img2 = read(IDS2);
            %figure(2);
            %imshow(imagem_reduzida);
            imagem_reduzida = imbinarize(imresize(img2,[30 30]));
            imagem_reduzida = imagem_reduzida(:);
            p2(:,i) = imagem_reduzida;
         
        end
        auxc = 1;
        t2 = zeros(10,100);
        for i=1:10
            for j=1:(10)
                t2(i,auxc)=1;
                auxc=auxc+1;
            end
        end
        %disp(t2);

    
    %PASTA 3
       p3 = zeros(30*30, 40);
        for i=1:(4*10)
            img3 = read(IDS3);
            imagem_reduzida = imbinarize(imresize(img3,[30 30]));
           % figure(3);
           % imshow(imagem_reduzida);
            imagem_reduzida = imagem_reduzida(:);
            p3(:,i) = imagem_reduzida;

      
        end
        auxc = 1;
        t3 = zeros(10,40);
        for i=1:10
            for j=1:(4)
                t3(i,auxc)=1;
                auxc=auxc+1;
            end

        end
       % disp(t3);
    
    
    %PASTA 4
       p4 = zeros(30*30, 10);
        for i=1:10
            img = read(IDS4);
            imagem_reduzida = imbinarize(imresize(img,[30 30]));  
            %figure(4);
           % imshow(imagem_reduzida);
            imagem_reduzida = imagem_reduzida(:);
            p4(:,i) = imagem_reduzida;

        end
        
    t4 = zeros(10,10);
    for i=1:10
        t4(i,i)=1;
    end
%   disp(t4);   
       
       

    %Treino da RN
    elseif opcao == 1

        
    if get(checkbox_p1,'Value')==0 && get(checkbox_p2,'Value')==0 && get(checkbox_p3,'Value')==0 && get(checkbox_p4,'Value')==0
        msgbox('É necessário pelo menos uma pasta estar selecionada para treinar a rede!', 'Erro','error');
        return
    end
    

        
        
    nCamadas=get(popupcamadas, 'Value');
    nNeuronios=get(txt_neuronios, 'String');
    nEpocas=get(txt_epocas, 'String');


    if str2double(nNeuronios)<1 
        msgbox('Número de neurónios inserido inválido!','Erro!','error');
        return;
    end
    if str2double(nEpocas)<1 
        msgbox('Número de épocas inserido inválido!','Erro!','error');
        return;
    end


    %função de treino
    camadas = {nCamadas+1};
    ATV_Fcn = get(p_camada1,'String');
    Treinar_Fcn = get(popuptreino,'String');
    for i=1:nCamadas
        switch i
            case 1
                camadas(i)=ATV_Fcn(get(p_camada1,'Value'));
            case 2
                camadas(i)=ATV_Fcn(get(p_camada2,'Value'));   
            case 3
                camadas(i)=ATV_Fcn(get(p_camada3,'Value')); 
            case 4
                camadas(i)=ATV_Fcn(get(p_camada4,'Value')); 
            case 5
                camadas(i)=ATV_Fcn(get(p_camada5,'Value')); 
        end
    end
    camadas((nCamadas+1))=ATV_Fcn(get(popupsaida,'Value'));

    Treino_Fcn = Treinar_Fcn(get(popuptreino,'Value'));

    p = [];
	t = [];


    if get(checkbox_p1,'Value')==1
        p=horzcat(p,p1);
        t=horzcat(t,t1);
    end
    if get(checkbox_p2,'Value')==1
        p=horzcat(p,p2);
        t=horzcat(t,t2);
    end
    
    if get(checkbox_p3,'Value')==1
        p=horzcat(p,p3);
        t=horzcat(t,t3);
    end
    
    if get(checkbox_p4,'Value')==1
        p=horzcat(p,p4);
        t=horzcat(t,t4);
    end


    nN=str2double(nNeuronios);
    %mesmo numero de neuronios por camadas
    if get(popupTop,'value')==1
        if nCamadas==1
            net = cascadeforwardnet(nN);
        elseif nCamadas==2
            net = cascadeforwardnet([nN nN]);
        elseif nCamadas==3
            net = cascadeforwardnet([nN nN nN]);
        elseif nCamadas==4
            net = cascadeforwardnet([nN nN nN nN]);
        elseif nCamadas==5
            net = cascadeforwardnet([nN nN nN nN nN]);
        end
        for i=1:nCamadas+1
           net.layers{i}.transferFcn = char(camadas(i));
        end

    elseif get(popupTop,'value')==2
        if nCamadas==1
            net = feedforwardnet(nN);
        elseif nCamadas==2
            net = feedforwardnet([nN nN]);
        elseif nCamadas==3
            net = feedforwardnet([nN nN nN]);
        elseif nCamadas==4
            net = feedforwardnet([nN nN nN nN]);
        elseif nCamadas==5
            net = feedforwardnet([nN nN nN nN nN]);
        end
        for i=1:nCamadas+1
           net.layers{i}.transferFcn = char(camadas(i));
        end
    else
         if nCamadas==1
            net = patternnet(nN);
        elseif nCamadas==2
            net = patternnet([nN nN]);
        elseif nCamadas==3
            net = patternnet([nN nN nN]);
        elseif nCamadas==4
            net = patternnet([nN nN nN nN]);
        elseif nCamadas==5
            net = patternnet([nN nN nN nN nN]);
        end
        for i=1:nCamadas+1
           net.layers{i}.transferFcn = char(camadas(i));
        end
    end


    if strcmpi(get(Switch_Seg, 'Value'),'On') == 1
        fprintf("aquiiiiiiiiii");
        seg1 = str2double(get(txt_treino, 'Value'));
       % fprintf("txt treino:: %s", txt_treino);
       % fprintf("seg1:: %d", seg1);clc
        seg2 = str2double(get(txt_val, 'Value'));
        seg3 = str2double(get(txt_teste, 'Value'));
        net.divideFcn = 'dividerand';
        %colocar os valores recebidos nos parametros
        net.divideParam.trainRatio = seg1;
        net.divideParam.valRatio = seg2;
        net.divideParam.testRatio = seg3;
    else
        %Todos os exemplos de input sao usados no treino
        net.divideFcn = '';
    end


     %funçao de treino
     net.trainFcn = char(Treino_Fcn);

     %nº de epocas de treino
     net.trainParam.epochs = str2double(nEpocas);

     %treinar a rede
     [net,tr]=train(net,p,t);
     
     
     %visualizar a rede
     %view(net);
     %disp(tr);
     %plotperf(tr); 

     if strcmpi(get(Switch_Seg, 'Value'),'On') == 1
          pTrain = p;
          tTrain = t;
     end
     

     
%Teste da RN
elseif opcao == 2 
    
    if get(checkbox_p1,'Value')==0 && get(checkbox_p2,'Value')==0 && get(checkbox_p3,'Value')==0 && get(checkbox_p4,'Value')==0
        msgbox('É necessário pelo menos uma pasta estar selecionada para testar a rede!', 'Erro','error');
        return
    end
    

    p = [];
    t = [];

    
    %PASTA 1
    if get(checkbox_p1,'Value')==1
        p = horzcat(p,p1);
        t = horzcat(t,t1);
    end

    %PASTA 2
    if get(checkbox_p2, 'Value') == 1
        p = horzcat(p,p2);
         t = horzcat( t,t2);
    end
    
    %PASTA 3
    if get(checkbox_p3, 'Value') == 1
        p = horzcat(p,p3);
        t = horzcat(t,t3);
    end

    %PASTA 4
    if get(checkbox_p4, 'Value') == 1
        p = horzcat(p,p4);
        t = horzcat(t,t4);
    end
    
     
     % Simular a rede e guardar o resultado na variavel s
     s = sim(net, p);
     disp(s);
     figure(1);
     %VISUALIZAR DESEMPENHO
     plotconfusion(t, s);
  

    if strcmpi(get(Switch_Seg, 'Value'),'On') == 1

        %Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
        r=0;
        for i=1:size(s,2)               % Para cada classificacao  
          [a b] = max(s(:,i));          % b guarda a linha onde encontrou valor mais alto da saida obtida
          [c d] = max(t(:,i));          % d guarda a linha onde encontrou valor mais alto da saida desejada
          if b == d                     % se estao na mesma linha, a classificacao foi correta (incrementa 1)
              r = r+1;
          end
        end

        accuracy = r/size(s,2)*100;
        fprintf('Precisao total %f\n', accuracy)

        % SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
        TInput = pTrain(:, tr.testInd);
        TTargets = tTrain(:, tr.testInd);

        s = sim(net, TInput);


        %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
        r=0;
        for i=1:size(tr.testInd,2)        % Para cada classificacao  
          [a b] = max(s(:,i));            % b guarda a linha onde encontrou valor mais alto da saida obtida
          [c d] = max(TTargets(:,i));     % d guarda a linha onde encontrou valor mais alto da saida desejada
          if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
              r = r+1;
          end
        end
        accuracy = r/size(tr.testInd,2)*100;
        fprintf('Precisao teste %f\n', accuracy)
    end


elseif opcao == 3
    
    if get(checkbox_p1, 'Value') == 0
        clear p1;
        clear t1;
    end

    if get(checkbox_p2, 'Value') == 0
        clear p2;
        clear t2;
    end
    
    if get(checkbox_p3, 'Value') == 0
        clear p3;
        clear t3;
    end
    
    if get(checkbox_p4, 'Value') == 0
        clear p4;
        clear t4;
    end
       
    save melhorRN;
    
    msgbox('Rede neuronal guardada com sucesso!','Sucesso');
    

elseif opcao == 4
    

    [fich, path] = uigetfile('*.mat');
    if fich == 0
        return
    end

    format = split(fich, '.');
    [r , ~] = size(format);
    if ~strcmp(format(r), 'mat')
        msgbox('O ficheiro selecionado não é um ficheiro do tipo .mat!', 'Erro', 'error');
        return
    end

    load (strcat(path,fich));
    msgbox('Rede neuronal carregada com sucesso!', 'Sucesso');
    
end

    
end
