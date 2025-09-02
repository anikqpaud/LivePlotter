my_in = input("Enter start ")
if my_in == "start"

    % Initialize instrument readout
    d=daq("ni");
    addinput(d, "Dev1", 0:1, "Voltage");
    addinput(d, "Dev1", "ai2", "Voltage");
    addoutput(d, "Dev1", "ao0", "Voltage");
    d.Channels
    d.Rate = 5000;

    % Initializing output signal
    outputSig = sin(linspace(0, 2*pi, d.Rate)');

    % Initialize tables
    % Create a timetable to store the data
    dataTable = timetable();

    % Initialize variables
    i=0;
    j=0;
    tic

    while i<15
        %start(d, "Continuous")
        time_el = seconds(toc);

        data = readwrite(d, outputSig, "OutputFormat", "Timetable")
        
       
        % Total time: time tracked by DAQ, time elapsed through code,
        % number of times the read function was used in each iteration
        data.Time = data.Time + time_el + seconds(i);
        tic
        
        % Plot data
        plot(decimate(seconds(data.Time), 100), decimate(data.Dev1_ai0, 100), "r-.")
        hold on
        plot(decimate(seconds(data.Time), 100), decimate(data.Dev1_ai1, 100), 'b-.')
        plot(decimate(seconds(data.Time), 100), decimate(data.Dev1_ai2, 100), 'g-.')

        % Math plot
        data.ai0_angle = cos(data.Dev1_ai0 * 2.35);
        %plot(data.Time, data.ai0_angle, 'm-.')

        % Write data to column matrix
        dataTable = [dataTable; data]; % Append new data to the timetable
        
        % Iteration variables
        i = i+1;
        j = j+1;

        % Backup log
        if j>5
            writetimetable(dataTable, 'liveplotter_backup.txt')
            j=0;
        end
    end

    % Write table to file
    %writetimetable(dataTable, 'liveplotter.txt');
    %dataTable = table(Time_el, Pin0, Pin1, Pin2)
    %writetable(dataTable, 'liveplotter.txt')
    
    % PSD generation
    

end
