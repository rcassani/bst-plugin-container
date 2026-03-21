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
    sProcess.SubGroup    = 'Test';
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
    % Get plugin description
    PlugDesc = bst_plugin('GetInstalled', plugName);

    % Actions 1 and 2 should be integrated on the Load function of the Plugin
    % Action 4 should be integrated on the Unload function of the Plugin

    % 1. Get tmp dir to bind container
    TmpDir = bst_get('BrainstormTmpDir', 0, plugName);
    volumes = {TmpDir, '/data'};

    % 2. Start container as daemon
    [isOk, errMsg, containerName] = bst_containers('RunContainer', plugName, PlugDesc.ImageSha, volumes, 1);

    % 3. Run command in container
    [isOk, cmdout] = bst_containers('ExecInContainer', containerName, '. /etc/os-release && echo $NAME > /data/wow.txt');

    % 4. Stop container
    isOk = bst_containers('StopContainer', containerName);

    % Read file created by container
    tagStr = strtrim(fileread(bst_fullfile(TmpDir, 'wow.txt')));

    % Append this text to the file comment
    sProcess.options.tag.Value = tagStr;
    sProcess.options.output.Value = 'name';
    OutputFiles = process_add_tag('Run', sProcess, sInput);

    % Reload studies
    db_reload_studies(sInput.iStudy);
end



