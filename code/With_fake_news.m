%------------Initialise model
close all;
clear all;

%------------- CONFIG ------------------------
M=6400; % no of connections
N=3200; % no of people
k=2*M/N; % avg degree
gamma=20; % N/G
G=N/gamma; % number of opinion
G = 2;
phi=0.98; % transition probability
withGraphics = 0;

Fake.add = 1; % 1 for fake news included, 0 for initial model
Fake.target = 1;    % target opinion fake news want to be;

Fake.medium = {'CNN','20mins','both'};
Fake.beta = [0.1,0.4];           % fake news affect possibility;
Fake.no = [1,3];               % number of fake news
Fake.affect_person = [2,1,1]; 

cost = 100*Fake.no(1) + 10*Fake.no(2);  %this is just a random equatioin, need to change
        
no_of_runs= 5; % amount of times to run simulation
duration= 1000; % number of iterations with each run
%------------- ENDCONFIG -----------------------

%[ClusterSizes, Connections] = OP_change_Cell(N,M,G,phi,duration,Fake);
[ClusterSizes,Connec_matrix,Opinion_matrix] = extended_model(N,M,k,G,phi,duration,no_of_runs,Fake);

if ( withGraphics )
    
    for t =1:duration
        mask = ones(N,duration);
        mask(:,t:end) = 0;
        bla = Opinion_matrix.*mask;
        clf; hold on; imagesc(bla);
        xlabel('iteration time');
        ylabel('People');
        title('Opinion\_Change')
        axis([0 duration 0 N])
        A(t) = getframe();
        pause(.1)
    end
    
    kermach = VideoWriter('Fake_news.avi');
    open(kermach)
    writeVideo(kermach,A)
    close(kermach)
    
else
    
    plot_averaged_results(ClusterSizes,N,M,G,phi,duration,no_of_runs,Fake);

end