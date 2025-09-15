% Solely visualizer program -> no writing signal, no data log

my_in = input("Enter start: ", "s");
if strcmp(my_in, "start")

    % Key variables
    inpin = "ai0";
    inpin2 = "ai1";
    inpin3 = "ai2";
    outpin = "ao0";
    devname = "Dev1";
    dev_rate = 1000;
    scans_count = 500;
    measure_period = 5 ; % Length of measurement time

    % Initialize DAQ device
    d=daq("ni");
    addinput(d, devname, inpin, "Voltage");
    addinput(d, devname, inpin2, "Voltage");
    addinput(d, devname, inpin3, "Voltage");
    % addoutput(d, devname, outpin, "Voltage");
    disp(d.Channels);
    d.Rate = dev_rate;

    % Create figure
    fig = figure;

    % Backup iteration variable
    j=0;

    % Continuous background acquisition function
    d.ScansAvailableFcnCount = scans_count;
    d.ScansAvailableFcn = @(src,evt) plotDataAvailable(src,evt, fig, startTime);

    % Start data acquisition
    disp("Starting acquisition");
    startTime = datetime('now');
    start(d, "Duration", seconds(measure_period));
    pause(measure_period);  

    % Stop data acquisition
    disp("stopping")
    stop(d)
end


% Functions

function plotDataAvailable(src, ~, fig, startTime)
    disp("Callback fired")
    [data, timestamps, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");
    elapsedTime = seconds(timestamps - second(startTime));


    if isvalid(fig)
        figure(fig);
        plot(elapsedTime, data);
        hold on
        title("Live data")
        drawnow; % Forces ML to graph it 
    end
end