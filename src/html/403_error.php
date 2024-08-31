<!DOCTYPE html>
<html lang="en">

<head>
    <title>[Error 403] Unexpected action detected!</title>
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Oxanium:wght@400&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Oxanium', cursive;
            box-sizing: border-box;
        }

        body {
            background-color: #f2f8ff;
            color: #333;
            text-align: center;
            padding: 50px;
        }

        #app {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        #app div:first-child {
            font-size: 128px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #2196f3;
        }

        #app .txt {
            font-size: 50px;
            line-height: 1.5;
            color: #333;
        }

        #app .txt span {
            font-size: 1.8rem;
            color: #666;
        }

        #app .txt strong {
            font-family: 'Courier New', Courier, monospace;
        }

        @keyframes blink {
            50% {
                border-color: transparent;
            }
        }
    </style>
</head>

<body>
<div id="app">
    <div>403</div>
    <div class="txt">
        Unexpected action detected!<br>
        <span>Please contact our help desk with request id:<br>
        <strong>
          <?= $_SERVER['REQUEST_ID'] ?>
        </strong>
      </span>
    </div>
</div>
</body>

</html>