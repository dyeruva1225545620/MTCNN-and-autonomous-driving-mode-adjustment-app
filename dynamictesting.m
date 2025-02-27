totalswitches = 0;
totalcollisions=0;
for i=1:1:10
rng('shuffle')
Hr=60+80*rand();%from firebase server
Rr=12+8*rand();%from firebase server
BMI=15+20*rand();%from firebase server
Sleep_duration=3+6*rand();%from firebase server
Intoxication_level=rand();%from firebase server
avg_speed=35;%from firebase server
initSpeedA=100*rand();
initSpeedB=100*rand();
fis = readfis('ReactionTimeFuzzy.fis');
inputValues = [BMI, Sleep_duration, Intoxication_level];
output = evalfis(fis, inputValues);
additionalTr = output(1);
Baseline_Tr=0.01*(Hr/Rr);
Tr=additionalTr+Baseline_Tr;
dynamicadvisory
if swap == 1
    ta=i*0.01;
    totalswitches=totalswitches+1;
    load_system('Level3Model.slx');
    set_param('Level3Model/VehicleKinematics/Saturation','LowerLimit',num2str(100*decelLim))
set_param('Level3Model/VehicleKinematics/vx','InitialCondition',num2str(initSpeedB))
set_param('Level3Model/CARA/VehicleKinematics/Saturation','LowerLimit',num2str(decelLim))
set_param('Level3Model/CARA/VehicleKinematics/vx','InitialCondition',num2str(initSpeedA))
set_param('Level3Model/Constant1','Value',num2str(ta))
set_param('Level3Model/Step','Time',num2str(Tr+ta))
set_param('Level3Model/Step','After',num2str(1.1*decelLim))
humanModel= sim('Level3Model.slx');
if (humanModel.sxB.Data(end) >= 0)
    totalcollisions=totalcollisions+1;
end
end
end
fprintf("There are %d switches of which %d result in collision",totalswitches,totalcollisions)