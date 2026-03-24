function varargout = process_os_tag( varargin )
% PROCESS_OS_TAG: Add a tag with the OS of a container

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c) University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Raymundo Cassani, 2026

eval(macro_method);
end


%% ===== GET DESCRIPTION =====
function sProcess = GetDescription() %#ok<DEFNU>
    % Description the process
    sProcess.Comment     = 'Add hostname to comment';
    sProcess.Category    = 'File';
    sProcess.SubGroup    = 'RC_TESTS';
    sProcess.Index       = 100;
    sProcess.Description = '';
    % Definition of the input accepted by this process
    sProcess.InputTypes  = {'data', 'results', 'timefreq', 'matrix', 'raw', 'pdata', 'presults', 'ptimefreq', 'pmatrix'};
    sProcess.OutputTypes = {'data', 'results', 'timefreq', 'matrix', 'raw', 'pdata', 'presults', 'ptimefreq', 'pmatrix'};
    sProcess.nInputs     = 1;
    sProcess.nMinFiles   = 1;
end


%% ===== FORMAT COMMENT =====
function Comment = FormatComment(sProcess)
    Comment = sProcess.Comment;
end


%% ===== RUN =====
function OutputFiles = Run(sProcess, sInput) %#ok<DEFNU>
    % Container plugin name
    plugName = 'cont_plug';

    % Ensure container plugin: Installs and/or Loads
    % Install container plugin === Import image into container engine
    % Load    container plugin === Run container (same name as container plugin)
    [ensureRes  errMsg] = bst_plugin('Ensure', plugName);
    % Retrieve info of container
    [containerName, isRunning, volumePairs, imageSha] = bst_containers('GetContainerInfo', plugName);

    % Run command in container
    if isRunning
        command = ['. /etc/os-release && echo $NAME > ' bst_fullfile(volumePairs{1,2}, 'wow.txt')];
        [isOk, cmdout] = bst_containers('ExecInContainer', containerName, command);
    end

    % Read file created by container
    tagStr = strtrim(fileread(bst_fullfile(volumePairs{1,1}, 'wow.txt')));
    
    % Unload container plugin === Stop container and Delete bind files
    if ensureRes > 0
        bst_plugin('Unload', plugName);
    end

    % Append this text to the file comment
    sProcess.options.tag.Value = tagStr;
    sProcess.options.output.Value = 'name';
    OutputFiles = process_add_tag('Run', sProcess, sInput);

    % Reload studies
    db_reload_studies(sInput.iStudy);
end

