#include "Windows.h"
#include "Memoryapi.h"
#include "DSound.h"

#include "stdio.h"
#include "intrin.h"
#include "malloc.h"

#include "cardcrafter.cpp"

global_variable BITMAPINFO window_buffer_info;
global_variable b32 running = true;

HRESULT directsound_create_stub(LPGUID p1, LPDIRECTSOUND* p2, LPUNKNOWN p3)
{
    return DSERR_NODRIVER;
}
typedef HRESULT (*directsound_create_fp) (LPGUID, LPDIRECTSOUND*, LPUNKNOWN);
directsound_create_fp directsound_create  = directsound_create_stub;
/*
void update_and_render_stub()
{}
typedef void (*update_and_render_fp) ();
update_and_render_fp update_and_render_ = update_and_render_stub;
*/
struct window_rect_dims
{
    s32 width;
    s32 height;
};

inline window_rect_dims get_window_rect_dims(HWND window)
{
    RECT window_rect;
    GetClientRect(window, &window_rect);
    window_rect_dims rect;
    rect.width = window_rect.right - window_rect.left;
    rect.height = window_rect.bottom - window_rect.top;
    return rect;
}
/*
void load_game_dll()
{
    HMODULE dll = LoadLibrary("cardcrafter.exe");
    if (dll)
        {
            update_and_render_ = (update_and_render_fp) GetProcAddress(dll, "update_and_render");
        }
}
*/
HANDLE dbg_open_file(u8* filename)
{
    return CreateFile((LPCSTR)filename, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, 0, OPEN_ALWAYS,
                      FILE_ATTRIBUTE_NORMAL, 0);
}

b32 dbg_read_entire_file(u8* filename, void* buffer, u32& buffer_size)
{
    HANDLE filehandle = dbg_open_file(filename);
    if (filehandle == INVALID_HANDLE_VALUE)
        {
            CloseHandle(filehandle);
            return false;
        }

    buffer_size = (u32) GetFileSize(filehandle, 0);
    if (buffer_size == INVALID_FILE_SIZE)
        {
            CloseHandle(filehandle);
            return false;
        }

    u32 bytes_read;
    ReadFile(filehandle, buffer, buffer_size, (LPDWORD)&bytes_read, 0);
    if (bytes_read != buffer_size)
        {
            CloseHandle(filehandle);
            return false;
        }

    CloseHandle(filehandle);
    return true;
}

b32 dbg_write_entire_file(u8* filename, void* buffer, u32 buffer_size)
{
    HANDLE filehandle = dbg_open_file(filename);
    if (filehandle == INVALID_HANDLE_VALUE)
        {
            CloseHandle(filehandle);
            return false;
        }

    u32 bytes_written;
    WriteFile(filehandle, buffer, buffer_size, (LPDWORD)&bytes_written, 0);
    if (bytes_written != buffer_size)
        {
            CloseHandle(filehandle);
            return false;
        }

    CloseHandle(filehandle);
     return true;
}

void load_directsound()
{
    HMODULE lib = LoadLibrary("dsound.dll");

    if (lib)
        {
            directsound_create = (directsound_create_fp) GetProcAddress(lib ,"DirectSoundCreate");
        }
}

void realloc_window_bitmap_buffer(int new_width, int new_height)
{
    if (memory.size)
        {
            memory.size = 0;
        }
        
    window_buffer_.width = new_width;
    window_buffer_.height = new_height;

    window_buffer_info.bmiHeader.biWidth = new_width;
    window_buffer_info.bmiHeader.biHeight = -new_height;
  
    s32 new_size = new_width*new_height*window_buffer_.bytes_per_pixel;
    window_buffer_.memory = memory.base;
    memory.size = new_size;
}

void resize_and_draw_window_bitmap(HDC dc, int window_width, int window_height)
{
    // @Note this is what actually blits to the scree/window
    // @Note what if we on purpose create a bitmap of different size in order to map it into the window??
    StretchDIBits(
                  dc,
                  0, 0, window_buffer_.width, window_buffer_.height,
                  0, 0, window_width, window_height,
                  window_buffer_.memory,
                  &window_buffer_info,
                  DIB_RGB_COLORS,
                  SRCCOPY
                  );
}

LRESULT CALLBACK window_procedure(HWND window, UINT message, WPARAM wParam, LPARAM lParam)
{
    LRESULT result = 0;
    
    switch(message)
        {
            
        case WM_ACTIVATEAPP:
            {
                OutputDebugString("WM_ACTIVATEAPP\n");
            } break;

        case WM_SIZE:
            {
                realloc_window_bitmap_buffer(
                                             get_window_rect_dims(window).width,
                                             get_window_rect_dims(window).height
                                             );
            } break;

        case WM_KEYDOWN:
        case WM_KEYUP:
        case WM_SYSKEYDOWN:
        case WM_SYSKEYUP:
            {
                //u16 repeat_count = lParam & 0x0000FFFF;
                
                switch(wParam)
                    {
                    case VK_UP:
                        {
                            frame_key.code = KEY_UP;
                        } break;
                    case VK_DOWN:
                        {
                            frame_key.code = KEY_DOWN;
                        } break;
                    case VK_RIGHT:
                        {
                            frame_key.code = KEY_RIGHT;
                        } break;
                    case VK_LEFT:
                        {
                            frame_key.code = KEY_LEFT;
                        } break;
                    default:
                        {}                      
                    }

                frame_key.is_down = (message == WM_KEYDOWN);
                frame_key.was_down = lParam & 0x40000000;
                
                if ((message == WM_SYSKEYUP && wParam == VK_F4) || (wParam == VK_ESCAPE))
                    {
                        running = false;
                    }
            } break;

        case WM_MOUSEMOVE:
            {
                cursor_.x = lParam & 0x0000FFFF;
                cursor_.y = lParam & 0xFFFF0000;
                cursor_.y = cursor_.y >> 16;
                mouse_frame_key.mouse_moved = true;
                // @Fail what if you get WM_MOUSEMOVE after WM_LBUTTONDOWN, and you reset the mouse_key.code but
                // you need to change that code value maybe ??
            } break;
            
        case WM_LBUTTONDOWN:
            //case WM_LBUTTONUP:
            {
                mouse_frame_key.code = M1;
                mouse_frame_key.is_down = true;
            } break;
            
        case WM_CLOSE:
            {
                OutputDebugString("WM_CLOSE\n");
                running = false;
                //PostQuitMessage(wParam);
            } break;

        case WM_DESTROY: // when closing window with X message WM_CLOSE is sent not this, so what do with this...?
            {
                OutputDebugString("WM_DESTROY\n");
                running = false;
                //PostQuitMessage(wParam);
            } break;

        case WM_PAINT: {} break;
            
        default:
            {
                result = DefWindowProc(window, message, wParam, lParam);
            }            
        }
    
    return result;
}

int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,  LPSTR lpCmdLine,  int nShowCmd)
{
    // @Robust failure points??
    
    timeBeginPeriod(1);

    //load_game_dll();

    dbg_readfile = dbg_read_entire_file;
    dbg_writefile = dbg_write_entire_file;
    
    WNDCLASS registered_window_infostruct = {};
    registered_window_infostruct.style = CS_OWNDC | CS_HREDRAW | CS_VREDRAW;
    registered_window_infostruct.lpfnWndProc = window_procedure;
    registered_window_infostruct.hInstance = hInstance;
    registered_window_infostruct.lpszClassName = "CardcrafterWindowClass";

    ATOM registered_window = RegisterClass(&registered_window_infostruct);

    HWND window = CreateWindow(
                               registered_window_infostruct.lpszClassName,
                               "Cardcrafter",
                               WS_VISIBLE | WS_OVERLAPPEDWINDOW,
                               CW_USEDEFAULT,
                               CW_USEDEFAULT,
                               CW_USEDEFAULT,
                               CW_USEDEFAULT,
                               0,
                               0,
                               hInstance,
                               0
                               );

    // default resolution is 1087x584, UL=(0,0)
    window_buffer_info.bmiHeader.biSize = sizeof(window_buffer_info.bmiHeader);
    window_buffer_info.bmiHeader.biPlanes = 1;
    window_buffer_info.bmiHeader.biBitCount = 4*8;
    window_buffer_info.bmiHeader.biCompression = BI_RGB;
    
    window_buffer_.bytes_per_pixel = 4;

    LARGE_INTEGER counter_frequency;
    QueryPerformanceFrequency(&counter_frequency);

    memory.base = VirtualAlloc(0, Gigabytes(4), MEM_COMMIT, PAGE_READWRITE);
    memory.capacity = Gigabytes(4);
    memory.size = 0;

    realloc_window_bitmap_buffer(get_window_rect_dims(window).width, get_window_rect_dims(window).height);
    
    while (running)
        {

            u64 begin_cycle_count = __rdtsc();

            LARGE_INTEGER begin_time_count;
            QueryPerformanceCounter(&begin_time_count);
            
            MSG message;
            PeekMessage(&message, 0, 0, 0, PM_REMOVE);

            if (message.message == WM_QUIT)
                {
                    running = false;
                }
            
            TranslateMessage(&message);
            DispatchMessage(&message);

            //update_and_render_();
            update_and_render();
            
            HDC dc = GetDC(window);
            resize_and_draw_window_bitmap(
                                          dc,
                                          get_window_rect_dims(window).width,
                                          get_window_rect_dims(window).height
                                          );
            ReleaseDC(window, dc);

            u64 end_cycle_count = __rdtsc();

            u64 cycles_per_frame = end_cycle_count - begin_cycle_count;
            
            LARGE_INTEGER end_time_count;
            QueryPerformanceCounter(&end_time_count);

            r64 ms_per_frame = ((end_time_count.QuadPart - begin_time_count.QuadPart)*1000.0)/counter_frequency.QuadPart;

            LARGE_INTEGER begin_sleep_time_count;
            QueryPerformanceCounter(&begin_sleep_time_count);

            // @Note this doesn't wait precisely for 60fps, a little more, a little less, how to improve this and does it matter??
            if (ms_per_frame < 16.67)
                {
                    Sleep(16.67-(u16)ms_per_frame);
                }
            
            LARGE_INTEGER end_sleep_time_count;
            QueryPerformanceCounter(&end_sleep_time_count);

            r64 slept_ms = ((end_sleep_time_count.QuadPart - begin_sleep_time_count.QuadPart)*1000.0)/counter_frequency.QuadPart;
            ms_per_frame+=slept_ms;
            
            r64 fps = 1000 / ms_per_frame;
            
            char debug_str[256];
            sprintf(debug_str,"%f fps : %f ms : %I64d cycles\n", fps, ms_per_frame, cycles_per_frame );

            OutputDebugStringA(debug_str);
            
        }

    return 0;
}
 
