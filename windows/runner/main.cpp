#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Harden DLL search order: only load from System32 and the application
  // directory.  This prevents DLL hijacking when the app is installed in a
  // user-writable location (CWE-427).
  ::SetDefaultDllDirectories(LOAD_LIBRARY_SEARCH_SYSTEM32 |
                             LOAD_LIBRARY_SEARCH_APPLICATION_DIR);

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  // Create a Job Object so all child processes (Ollama, proxy, vLLM) are
  // automatically terminated if Candela crashes or is force-killed.
  // The handle intentionally leaks — it lives for the process lifetime.
  // When the OS closes it on exit, JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
  // triggers termination of every associated child process.
  HANDLE hJob = ::CreateJobObject(NULL, NULL);
  if (hJob != NULL) {
    JOBOBJECT_EXTENDED_LIMIT_INFORMATION jeli = {};
    jeli.BasicLimitInformation.LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
    ::SetInformationJobObject(hJob, JobObjectExtendedLimitInformation, &jeli,
                              sizeof(jeli));
    ::AssignProcessToJobObject(hJob, ::GetCurrentProcess());
  }


  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  // Let Windows choose the initial position (centered/cascaded).
  // Size matches Flutter's WindowOptions(size: Size(1280, 820)).
  Win32Window::Point origin(CW_USEDEFAULT, CW_USEDEFAULT);
  Win32Window::Size size(1280, 820);
  if (!window.Create(L"Candela", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
