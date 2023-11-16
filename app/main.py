from fastapi import FastAPI, HTTPException, status
from fastapi.responses import FileResponse
import subprocess
import os

app = FastAPI()

def generate_file():
    """
    Function to generate the file using an external script.
    """
    # Example: Running an external script
    subprocess.run(["/export/scripts/collect.sh"], check=True)


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/export/all")
async def get_all_logs():
    try:
        # Call the function to generate the file
        generate_file()

        # Get the path of the generated file
        file_path = "/export/logs.zip"

        # Check if the file exists
        if not os.path.exists(file_path):
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="File not found")

        # Create a FileResponse
        return FileResponse(file_path)
    except Exception as e:
        # Handle exceptions based on your requirements
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

